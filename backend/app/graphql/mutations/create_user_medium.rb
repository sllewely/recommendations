class Mutations::CreateUserMedium < Mutations::BaseMutation
  argument :name, String
  argument :media_category, Types::MediaCategoryEnum
  argument :rating, Integer, required: false
  argument :notes, String, required: false

  field :user_medium, Types::UserMediumType
  field :errors, [String], null: false

  def resolve(name:, media_category:, rating: nil, notes: nil)
    current_user = context[:current_user]
    medium = Medium.find_or_create_by(name: name, media_category: media_category)
    if !medium
      return {
        user_medium: nil,
        errors: medium.errors.full_messages
      }
    end
    user_medium = UserMedium.new(user: current_user, medium: medium, rating: rating, notes: notes)
    if user_medium.save
      {
        user_medium: user_medium,
        errors: []
      }
    else
      {
        user_medium: nil,
        errors: user_medium.errors.full_messages
      }
    end
  end

end
