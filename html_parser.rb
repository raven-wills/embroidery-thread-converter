# HTML Table Parser for Thread Color Data
# Save this as html_parser.rb in your Rails root directory

require 'nokogiri'

class ThreadColorHTMLParser
  def initialize(html_file_path)
    @html_file_path = html_file_path
    @thread_data = []
  end

  def parse!
    puts "Parsing HTML file: #{@html_file_path}"

    # Read the HTML file
    html_content = File.read(@html_file_path)
    doc = Nokogiri::HTML(html_content)

    # Find all tables
    tables = doc.css('table')
    puts "Found #{tables.length} tables"

    # Look for the data table (usually the second one or the one with tbody)
    data_table = find_data_table(tables)

    if data_table
      extract_thread_data(data_table)
    else
      puts "Could not find data table!"
    end

    @thread_data
  end

  def generate_ruby_model_code
    puts "Generating Ruby model code with #{@thread_data.length} thread colors..."

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
    where("\#{brand} = ? OR \#{brand} LIKE ? OR \#{brand} LIKE ? OR \#{brand} LIKE ?",
          number,
          "\#{number}/%",
          "%/\#{number}",
          "%/\#{number}/%").first
  end

  # Parse thread numbers from various input formats
  def self.parse_thread_numbers(input)
    return [] if input.blank?

    input.strip
         .split(/[,\n\r\s]+/)
         .map(&:strip)
         .reject(&:blank?)
  end

  # Format the target value for display
  def self.format_target_value(value)
    return nil if value.blank? || value == '-'
    value
  end

  # Complete thread color dataset extracted from website
  def self.seed_data!
    puts "Seeding thread color data..."

    thread_data = [
RUBY

    # Add each thread color as a hash
    @thread_data.each_with_index do |thread, index|
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
      model_code += "," unless index == @thread_data.length - 1
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

  private

  def find_data_table(tables)
    # Look for table with tbody (data table)
    data_table = tables.find { |table| table.css('tbody').any? }

    # If no tbody, use the larger table
    data_table ||= tables.max_by { |table| table.css('tr').length }

    puts "Using table with #{data_table.css('tr').length} rows" if data_table
    data_table
  end

  def extract_thread_data(table)
    rows = table.css('tbody tr')
    puts "Extracting data from #{rows.length} rows..."

    rows.each_with_index do |row, index|
      cells = row.css('td')
      next if cells.empty?

      # Extract text from each cell, handling images and nested content
      thread_row = extract_row_data(cells)

      if thread_row[:dmc] # Only add if we have a DMC value
        @thread_data << thread_row
        puts "Extracted row #{index + 1}: #{thread_row[:dmc]}" if index < 5 # Show first 5
      end
    end

    puts "Successfully extracted #{@thread_data.length} thread colors"
  end

  def extract_row_data(cells)
    # Map table columns to our database columns
    # Adjust these indices based on your table structure
    {
      dmc: clean_value(cells[1]&.text), # DMC column
      anchor: clean_value(cells[2]&.text), # ANC column
      madeira: clean_value(cells[4]&.text), # MADEIRA column
      cosmo: clean_value(cells[6]&.text), # COSMO column
      olympus: clean_value(cells[7]&.text), # OLYMPUS column
      jp_coats: clean_value(cells[5]&.text), # J&P column
      lecien: nil, # Not in original table
      sullivans: nil, # Not in original table
      aurifil: nil, # Not in original table
      weeks: nil, # Not in original table
      gentle_art: nil, # Not in original table
      classic_colorworks: nil # Not in original table
    }
  end

  def clean_value(value)
    return nil if value.nil?

    # Get all text content, removing nested HTML tags
    cleaned = value.gsub(/<[^>]*>/, '').strip
    return nil if cleaned.empty? || cleaned == '-'

    # Handle special cases and normalize whitespace
    cleaned.gsub(/\s+/, ' ').strip
  end
end

# Usage script
if __FILE__ == $0
  html_file = 'table_data.html' # Change this to your HTML file name

  unless File.exist?(html_file)
    puts "Error: HTML file '#{html_file}' not found!"
    puts "Please save your copied HTML content to '#{html_file}' in the Rails root directory."
    exit 1
  end

  # Parse the HTML
  parser = ThreadColorHTMLParser.new(html_file)
  thread_data = parser.parse!

  if thread_data.any?
    # Generate the Ruby model code
    model_code = parser.generate_ruby_model_code

    # Write to file
    File.write('app/models/thread_color_updated.rb', model_code)

    puts "\\n✅ Successfully generated updated model with #{thread_data.length} thread colors!"
    puts "Generated file: app/models/thread_color_updated.rb"
    puts ""
    puts "Next steps:"
    puts "1. Review the generated file"
    puts "2. Replace app/models/thread_color.rb with the new content"
    puts "3. Run: rails db:reset"
    puts "4. Run: rails server"
    puts ""
    puts "Your thread converter will have the complete dataset! 🧵"
  else
    puts "❌ No thread data was extracted. Please check your HTML file structure."
  end
end
