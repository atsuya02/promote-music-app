module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.
    field :users, [Types::UserType], null: false do
      argument :offset, Int, required: true
      argument :limit, Int, required: true
    end
    def users(offset:, limit:)
      User.includes(:artists).limit(limit).offset(offset)
    end

    field :user_by_name, Types::UserType, null: false do
      argument :name, String, required: true
    end
    def user_by_name(name:)
      if user = User.find_by(name: name)
        user
      else
        raise GraphQL::ExecutionError, "User not found."
      end
    end

    field :current_user_artists, [Types::ArtistType], null: false do
      argument :user_name, String, required: true
      argument :offset, Int, required: true
      argument :limit, Int, required: true
    end
    def current_user_artists(user_name:,offset:, limit:)
      if artists = User.find_by(name: user_name).artists.limit(limit).offset(offset)
        artists
      else
        raise GraphQL::ExecutionError, "User not found."
      end
    end

    field :artists, [Types::ArtistType], null: false do
      argument :offset, Int, required: true
      argument :limit, Int, required: true
    end
    def artists(offset:, limit:)
      Artist.limit(limit).offset(offset)
    end

    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World!"
    end
  end
end
