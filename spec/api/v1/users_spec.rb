require 'rails_helper'

describe 'Users API' do
  describe 'GET /index' do

    context 'unauthorized' do
      it 'returns 401 status code if there is no access_token' do
        do_request
        expect(response.status).to eq 401
      end

      it 'returns 401 status code if access_token is invalid' do
        do_request(access_token: '000')
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { Rails.application.secrets.access_token = "qwerty" }
      let!(:users) { create_list(:user, 2) }
      let(:user) { users.first }
      before { do_request access_token: access_token }

      it 'returns 201 status code' do
        expect(response).to be_success
      end

      it 'returns list of users' do
        expect(response.body).to have_json_size(2).at_path("users")
      end

      %w(id name created_at updated_at).each do |attr|
        it "user object contains #{attr}" do
          expect(response.body).to be_json_eql(user.send(attr.to_sym).to_json).at_path("users/0/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/users', params: { format: :json }.merge(options)
    end
  end
end
