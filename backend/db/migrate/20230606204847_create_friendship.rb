class CreateFriendship < ActiveRecord::Migration[7.0]
  def change
    create_table :friendships do |t|
      t.integer :from_user_id, index: true
      t.integer :to_user_id, index: true
      t.datetime :accepted_at, null: true
      t.timestamps
    end
  end
end
