require 'rails_helper'

describe 'Messages API' do
  describe 'POST /single' do

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
      # let!(:user) { create(:user) }
      let(:create_message) do
        do_request access_token: access_token,
                   message: attributes_for(:message)
      end
      let(:create_invalid_message) do
        do_request access_token: access_token,
                   message: attributes_for(:invalid_message)
      end

      context 'with valid attributes' do
        it 'returns 201 status code' do
          create_message
          expect(response).to be_success
        end
      end

      context 'with invalid attributes' do
        it 'returns bad request status' do
          create_invalid_message
          expect(response.status).to eql 400
        end
      end
    end

    def do_request(options = {})
      post '/api/v1/messages/single', params: { format: :json }.merge(options)
    end
  end

  describe 'POST /batch' do

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
      let(:create_batch_messages) do
        do_request access_token: access_token,
                   message:
                   {
                     user_id: users.map(&:id).join(","),
                     messenger: BaseMessenger::MESSENGERS.join(","),
                     body: "Some text"
                   }
      end
      let(:create_invalid_batch_messages) do
        do_request access_token: access_token,
                    message: attributes_for(:invalid_message)
      end

      context 'with valid attributes' do
        it 'returns 201 status code' do
          create_batch_messages
          expect(response).to be_success
        end
      end

      context 'with invalid attributes' do
        it 'returns bad request status' do
          create_invalid_batch_messages
          expect(response.status).to eql 400
        end
      end
    end

    def do_request(options = {})
      post '/api/v1/messages/batch', params: { format: :json }.merge(options)
    end
  end

end
