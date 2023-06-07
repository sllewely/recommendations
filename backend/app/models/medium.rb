class Medium < ApplicationRecord
  has_many :user_media
  has_many :users, through: :user_media
end
