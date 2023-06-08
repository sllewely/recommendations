# frozen_string_literal: true

module Types
  class MediumType < Types::BaseObject
    field :id, ID, null: false
    field :name, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :media_category, MediaCategoryEnum
  end
end
