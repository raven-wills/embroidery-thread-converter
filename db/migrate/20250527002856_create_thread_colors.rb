# db/migrate/20250526000001_create_thread_colors.rb
class CreateThreadColors < ActiveRecord::Migration[7.1]
  def change
    create_table :thread_colors do |t|
      # Main brand columns - these are required for your conversion tool
      t.string :dmc, null: false
      t.string :anchor
      t.string :madeira
      t.string :cosmo
      t.string :olympus
      t.string :jp_coats
      t.string :lecien
      t.string :sullivans
      t.string :aurifil
      t.string :weeks
      t.string :gentle_art
      t.string :classic_colorworks

      # Future expansion columns - add these now for scalability
      t.string :color_hex      # For storing hex color values like "#FF5733"
      t.text :color_name       # For storing descriptive color names
      t.string :image_url      # For storing color swatch image URLs

      t.timestamps
    end

    # Indexes for fast lookups - important for performance
    add_index :thread_colors, :dmc, unique: true
    add_index :thread_colors, :anchor
    add_index :thread_colors, :madeira
    add_index :thread_colors, :cosmo
    add_index :thread_colors, :olympus
    add_index :thread_colors, :jp_coats
    add_index :thread_colors, :lecien
    add_index :thread_colors, :sullivans
    add_index :thread_colors, :aurifil
    add_index :thread_colors, :weeks
    add_index :thread_colors, :gentle_art
    add_index :thread_colors, :classic_colorworks
  end
end
