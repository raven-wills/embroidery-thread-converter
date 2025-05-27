# CSV to Ruby Hash Converter for Thread Colors
# Place this script in your Rails root directory and run: ruby csv_converter.rb

require 'csv'

def convert_csv_to_ruby_data(csv_file_path)
  puts "Converting CSV to Ruby hash format..."

  ruby_data = []

  CSV.foreach(csv_file_path, headers: true) do |row|
    # Convert CSV columns to Ruby hash with snake_case keys
    thread_data = {
      dmc: clean_value(row['DMC']),
      anchor: clean_value(row['Anchor']),
      madeira: clean_value(row['Madeira']),
      cosmo: clean_value(row['Cosmo']),
      olympus: clean_value(row['Olympus']),
      jp_coats: clean_value(row['JP Coats']),
      lecien: clean_value(row['Lecien']),
      sullivans: clean_value(row['Sullivans']),
      aurifil: clean_value(row['Aurifil']),
      weeks: clean_value(row['Weeks']),
      gentle_art: clean_value(row['Gentle Art']),
      classic_colorworks: clean_value(row['Classic Colorworks'])
    }

    ruby_data << thread_data
  end

  puts "Converted #{ruby_data.length} thread colors"
  ruby_data
end

def clean_value(value)
  # Convert empty strings, "-", and whitespace to nil
  return nil if value.nil? || value.strip.empty? || value.strip == '-'
  value.strip
end

def generate_model_code(ruby_data)
  puts "Generating updated model code..."

  # Start building the model file content
  model_code = <<~RUBY
# app/models/thread_color.rb
class ThreadColor < ApplicationRecord
  validates :dmc, presence: true, uniqueness: true

  # All the brand columns - using snake_case for Rails conventions
  BRANDS = %w[
    dmc anchor madeira cosmo olympus jp_coats
    lecien sullivans aurifil weeks gentle_art classic_colorworks
  ].freeze

  # Human-readable brand names for display
  BRAND_NAMES = {
    'dmc' => 'DMC',
    'anchor' => 'Anchor',
    'madeira' => 'Madeira',
    'cosmo' => 'Cosmo',
    'olympus' => 'Olympus',
    'jp_coats' => 'JP Coats',
    'lecien' => 'Lecien',
    'sullivans' => 'Sullivans',
    'aurifil' => 'Aurifil',
    'weeks' => 'Weeks',
    'gentle_art' => 'Gentle Art',
    'classic_colorworks' => 'Classic Colorworks'
  }.freeze

  # Find conversion between any two brands
  def self.convert_threads(from_brand, to_brand, thread_numbers)
    # Parse input - handle various formats
    numbers = parse_thread_numbers(thread_numbers)

    results = numbers.map do |number|
      thread_color = find_by_brand_and_number(from_brand, number)
      target_value = thread_color&.send(to_brand)

      {
        source_number: number,
        target_number: format_target_value(target_value),
        found: target_value.present? && target_value != '-'
      }
    end

    results
  end

  # Find thread color by brand and number (handles multiple values like "111/110")
  def self.find_by_brand_and_number(brand, number)
    where("#{brand} = ? OR #{brand} LIKE ? OR #{brand} LIKE ? OR #{brand} LIKE ?",
          number,
          "#{number}/%",
          "%/#{number}",
          "%/#{number}/%").first
  end

  # Parse thread numbers from various input formats
  def self.parse_thread_numbers(input)
    return [] if input.blank?

    input.strip
         .split(/[,\\n\\r\\s]+/)
         .map(&:strip)
         .reject(&:blank?)
  end

  # Format the target value for display
  def self.format_target_value(value)
    return nil if value.blank? || value == '-'
    value
  end

  # Complete thread color dataset
  def self.seed_data!
    puts "Seeding thread color data..."

    thread_data = [

  # Add each thread color as a hash
  ruby_data.each_with_index do |thread, index|
    model_code += "      {\n"
    thread.each do |key, value|
      if value.nil?
        model_code += "        #{key}: nil"
      else
        model_code += "        #{key}: '#{value}'"
      end
      model_code += "," unless key == thread.keys.last
      model_code += "\n"
    end
    model_code += "      }"
    model_code += "," unless index == ruby_data.length - 1
    model_code += "\n"
  end

  # Close the method and class
  model_code += <<~RUBY
    ]

    thread_data.each do |data|
      ThreadColor.find_or_create_by(dmc: data[:dmc]) do |thread|
        data.each { |key, value| thread.send("\#{key}=", value) }
      end
    end

    puts "Seeded \#{ThreadColor.count} thread colors"
  end
end
RUBY

  model_code
end

# Main execution
if __FILE__ == $0
  # Update this path to your CSV file location
  csv_file = 'all_brand_conversions.csv'  # Change this to your actual file name

  unless File.exist?(csv_file)
    puts "Error: CSV file '#{csv_file}' not found!"
    puts "Please make sure your CSV file is in the Rails root directory."
    puts "Or update the csv_file variable in this script."
    exit 1
  end

  # Convert CSV to Ruby data
  ruby_data = convert_csv_to_ruby_data(csv_file)

  # Generate the complete model code
  model_code = generate_model_code(ruby_data)

  # Write to a new file
  File.write('app/models/thread_color_updated.rb', model_code)

  puts "✅ Generated updated model file: app/models/thread_color_updated.rb"
  puts ""
  puts "Next steps:"
  puts "1. Review the generated file"
  puts "2. Replace your current app/models/thread_color.rb with the new content"
  puts "3. Run: rails db:reset (this will recreate and seed the database)"
  puts "4. Run: rails server"
  puts ""
  puts "Your thread converter will now have your complete dataset! 🧵"
end
