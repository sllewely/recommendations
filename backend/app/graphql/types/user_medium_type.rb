# frozen_string_literal: true

module Types
  class UserMediumType < Types::BaseObject
    field :id, ID, null: false
    field :medium_id, Integer
    field :medium, Types::MediumType
    field :user_id, Integer
    field :user, Types::UserType
    field :rating, Integer
    field :notes, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
