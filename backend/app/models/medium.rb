class Medium < ApplicationRecord
  has_many :user_media
  has_many :users, through: :user_media

  # https://api.rubyonrails.org/v5.1.7/classes/ActiveRecord/Enum.html
  enum media_type: [:book, :movie, :tv_show]

  validates :media_type, inclusion: { in: media_type}
end
