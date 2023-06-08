# https://graphql-ruby.org/type_definitions/enums
class Types::MediaCategoryEnum < Types::BaseEnum
  Medium.media_categories.each { |(media_type, _val)| value(media_type) }
end