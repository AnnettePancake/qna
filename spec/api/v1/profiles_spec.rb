# frozen_string_literal: true
require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        get '/api/v1/profiles/me', params: { format: :json,
                                             access_token: access_token.token }
      end

      it_behaves_like 'API Status 200'

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

    def do_request(options = {})
      get '/api/v1/profiles/me', params: { format: :json }.merge(options)
    end
  end

  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:me) { create(:user) }
      let(:users_list) { create_pair(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        get '/api/v1/profiles', params: { format: :json,
                                          access_token: access_token.token }
      end

      it_behaves_like 'API Status 200'

      it 'contains list of users except me' do
        expect(response.body).not_to be_json_eql(users_list.to_json)
      end

      it 'does not contain profile of me' do
        expect(response.body).not_to include_json(me.to_json)
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles/me', params: { format: :json }.merge(options)
    end
  end
end
