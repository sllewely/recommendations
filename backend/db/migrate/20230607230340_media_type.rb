class MediaType < ActiveRecord::Migration[7.0]
  def change
    add_column :media, :media_category, :integer
  end
end
