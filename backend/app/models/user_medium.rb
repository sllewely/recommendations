class UserMedium < ApplicationRecord
  belongs_to :user
  belongs_to :medium

  def self.with_access(current_user)
    UserMedium.where(user_id: current_user.id)
  end
end
