class Mutations::CreateMedium < Mutations::BaseMutation
  argument :name, String
  argument :media_category, Types::MediaCategoryEnum

  field :medium, Types::MediumType
  field :errors, [String], null: false

  def resolve(name:, media_category:)
    medium = Medium.new(name: name, media_category: media_category)
    if medium.save
      {
        medium: medium,
        errors: []
      }
    else
      {
        medium: nil,
        errors: medium.errors.full_messages
      }
    end
  end

end