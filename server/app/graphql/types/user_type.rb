module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :artists, [Types::ArtistType], null: false
  end
end
