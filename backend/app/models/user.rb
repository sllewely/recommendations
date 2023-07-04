class User < ApplicationRecord
  has_many :friendships_requested, class_name: 'Friendship', foreign_key: 'from_user_id', inverse_of: :requestor
  has_many :friends_requested, class_name: 'User', through: :friendships_requested, source: :requested

  has_many :friendship_requests, class_name: 'Friendship', foreign_key: 'to_user_id', inverse_of: :requested
  has_many :friend_requests, class_name: 'User', through: :friendship_requests, source: :requestor

  has_many :user_media
  has_many :media, through: :user_media

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, format: URI::MailTo::EMAIL_REGEXP
  validates :first_name, :last_name, :email, presence: true

  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end

  def friends
    friends_one = friends_requested.where('friendships.accepted_at IS NOT NULL').select(:id).to_sql
    friends_two = friend_requests.where('friendships.accepted_at IS NOT NULL').select(:id).to_sql
    subquery = [friends_one, friends_two].join(" UNION ")
    User.where("id IN (#{subquery})")
  end
end
