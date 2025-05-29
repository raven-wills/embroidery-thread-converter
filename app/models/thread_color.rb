require "yaml"

class ThreadColor < ApplicationRecord
  validates :dmc, presence: true, uniqueness: true

  BRANDS = %w[
    dmc anchor cosmo jp_coats sullivans presenica madeira appletons kreinik luca_s semco olympus y_d
  ].freeze

  # Load brand display names from YAML
  BRAND_NAMES = YAML.load_file(Rails.root.join("config", "thread_data.yml"))["brands"]
    .transform_values { |v| v["name"] }
    .freeze

  # Find conversion between any two brands
  def self.convert_threads(from_brand, to_brand, thread_numbers)
    numbers = parse_thread_numbers(thread_numbers)

    results = numbers.map do |number|
      thread_color = find_by_brand_and_number(from_brand, number)
      target_value = thread_color&.send(to_brand)

      {
        source_number: number,
        target_number: format_target_value(target_value),
        found: target_value.present? && target_value != "-"
      }
    end

    results
  end

  # Find thread color by brand and number (handles multiple values like "111/110")
  def self.find_by_brand_and_number(brand, number)
    unless BRANDS.include?(brand.to_s)
      raise ArgumentError, "Invalid brand: #{brand}"
    end

    table = arel_table
    brand_column = table[brand]

    exact_match = brand_column.eq(number)
    starts_with = brand_column.matches("#{number}/%")
    ends_with = brand_column.matches("%/#{number}")
    contains = brand_column.matches("%/#{number}/%")

    where(exact_match.or(starts_with).or(ends_with).or(contains)).first
  end

  # Parse thread numbers from various input formats
  def self.parse_thread_numbers(input)
    return [] if input.blank?

    input.strip
         .split(/[,\s]+/)
         .map(&:strip)
         .reject(&:blank?)
  end

  # Format the target value for display
  def self.format_target_value(value)
    return nil if value.blank? || value == "-"
    value
  end
end
