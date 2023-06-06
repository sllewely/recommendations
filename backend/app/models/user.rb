class User < ApplicationRecord
  has_many :friends_requested, class_name: 'Friendship', foreign_key: 'from_user_id', inverse_of: :requestor
  has_many :friends_possible, -> { where accepted_at: nil }, class_name: 'Friendship', through: :friends_requested
  has_many :friends_accepted, -> { where.not accepted_at: nil }, class_name: 'Friendship', through: :friends_requested

  has_many :friend_requests, class_name: 'Friendship', foreign_key: 'to_user_id', inverse_of: :requested
  has_many :pending_friends, -> { where accepted_at: nil }, class_name: 'Friendship', through: :friend_requests
  has_many :accepted_friends, -> { where.not accepted_at: nil }, class_name: 'Friendship', through: :friend_requests

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, format: URI::MailTo::EMAIL_REGEXP

  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end
end
