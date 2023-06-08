module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.
    field :users,
          [Types::UserType],
          null: false,
          description: "Return a list of users"
    def users
      User.all
    end

    field :user, Types::UserType, null: false do
      argument :id, ID, required: true
    end
    def user(id:)
      User.find(id)
    end

    field :user_media,
          [Types::UserMediumType],
          null: false,
          description: "Return a list of user media"
    def user_media
      UserMedium.all
    end

    field :media,
          [Types::MediumType],
          null: false,
          description: "Return a list of media"
    def media
      Medium.all
    end

    field :medium, Types::MediumType, null: false do
      argument :name, String, required: true
    end
    def medium(name:)
      Medium.find_by(name: name)
    end

    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World!"
    end
  end
end
