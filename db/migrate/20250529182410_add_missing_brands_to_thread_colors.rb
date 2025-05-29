class AddMissingBrandsToThreadColors < ActiveRecord::Migration[8.0]
  def change
    add_column :thread_colors, :presenica, :string
    add_column :thread_colors, :appletons, :string
    add_column :thread_colors, :kreinik, :string
    add_column :thread_colors, :luca_s, :string
    add_column :thread_colors, :semco, :string
    add_column :thread_colors, :y_d, :string
  end
end
