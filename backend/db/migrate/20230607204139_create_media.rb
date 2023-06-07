class CreateMedia < ActiveRecord::Migration[7.0]
  def change
    create_table :media do |t|
      t.string :name

      t.timestamps
    end

    create_table :user_media do |t|
      t.belongs_to :medium
      t.belongs_to :user

      t.integer :rating
      t.text :notes

      t.timestamps
    end
  end
end
