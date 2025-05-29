class RemoveUnusedBrandsFromThreadColors < ActiveRecord::Migration[8.0]
  def change
    remove_column :thread_colors, :aurifil, :string
    remove_column :thread_colors, :weeks, :string
    remove_column :thread_colors, :gentle_art, :string
    remove_column :thread_colors, :classic_colorworks, :string
    remove_column :thread_colors, :lecien, :string
    remove_column :thread_colors, :color_hex, :string
    remove_column :thread_colors, :color_name, :text
    remove_column :thread_colors, :image_url, :string
  end
end
