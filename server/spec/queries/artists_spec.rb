require 'rails_helper'

RSpec.describe Artist, type: :request do
  describe 'artists_query' do
    let(:query_string) {
      <<-GraphQL
        query ($offset: Int!, $limit: Int!) {
          artists(offset: $offset, limit: $limit) {
            id
            name
          }
        }
      GraphQL
    }
    let(:result) { ServerSchema.execute(query_string, variables: { offset: 0, limit: 5 }) }
    let(:result_data) { result['data']['artists'] }

    context 'when artists exist' do
      before do
        create_list(:artist, 5) do |artist, i|
          artist.name = "artist#{i + 1}"
        end
      end

      it 'should return right artists' do
        expect(result_data).to eq [
                                    {"id" => "1", "name" => "artist1"},
                                    {"id" => "2", "name" => "artist2"},
                                    {"id" => "3", "name" => "artist3"},
                                    {"id" => "4", "name" => "artist4"},
                                    {"id" => "5", "name" => "artist5"}
                                  ]
      end
    end

    context 'when artist does not exist' do
      it 'should return empty array' do
        expect(result_data).to eq []
      end
    end
  end
end
