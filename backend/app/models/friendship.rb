class Friendship < ApplicationRecord
    belongs_to :requestor, class_name: 'User', foreign_key: 'from_user_id', inverse_of: :friends_requested
    belongs_to :requested, class_name: 'User', foreign_key: 'to_user_id', inverse_of: :friend_requests
    validates :from_user_id, uniqueness: { scope: :to_user_id }
    validates :to_user_id, comparison: { other_than: :from_user_id }
end
