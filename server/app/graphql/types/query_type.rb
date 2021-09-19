module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.
    field :user, Types::UserType, null: false do
      argument :name, String, required: true
    end
    def user(name:)
      if user = User.find_by(name: name)
        user
      else
        raise GraphQL::ExecutionError, "Failed!"
      end
    end

    field :users, [Types::UserType], null: false
    def users
      User.all
    end

    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World!"
    end
  end
end