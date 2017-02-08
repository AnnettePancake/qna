# frozen_string_literal: true
require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles/me', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        get '/api/v1/profiles/me', params: { format: :json,
                                             access_token: access_token.token }
      end

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr.to_s)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).not_to have_json_path(attr.to_s)
        end
      end
    end
  end

  describe 'GET /list' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/list', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles/list', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end
  end

  context 'authorized' do
    let(:me) { create(:user) }
    let(:users_list) { create_pair(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }

    before do
      get '/api/v1/profiles/list', params: { format: :json,
                                             access_token: access_token.token }
    end

    it 'returns 200 status' do
      expect(response).to be_success
    end

    it 'contains list of users except me' do
      expect(response.body).not_to be_json_eql(users_list.to_json)
    end

    it 'does not contain profile of me' do
      expect(response.body).not_to include_json(me.to_json)
    end
  end
end
