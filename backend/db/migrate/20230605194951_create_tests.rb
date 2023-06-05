class CreateTests < ActiveRecord::Migration[7.0]
  def change
    create_table :tests do |t|
      t.string :cat_name
      t.integer :legs

      t.timestamps
    end
  end
end
