# frozen_string_literal: true
require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:questions) { create_pair(:question) }
      let!(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }
      let(:path) { '0/' }
      let(:answer_path) { '0/answers/0/' }

      before do
        get '/api/v1/questions', params: { format: :json, access_token: access_token.token }
      end

      it_behaves_like 'API Status 200'
      it_behaves_like 'API List'
      it_behaves_like 'API Question attributes'

      it 'question object contains short_title' do
        expect(response.body)
          .to be_json_eql(question.title.truncate(10).to_json)
          .at_path('0/short_title')
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body). to have_json_size(1).at_path('0/answers')
        end

        it_behaves_like 'API Answer attributes'
      end
    end

    def do_request(options = {})
      get '/api/v1/questions', params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let(:question) { create(:question) }
    let(:path) { '' }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:comment) { create(:comment, commentable: question) }
      let!(:attachment) { create(:attachment, attachable: question) }

      before do
        get "/api/v1/questions/#{question.id}", params: { format: :json,
                                                          access_token: access_token.token }
      end

      it_behaves_like 'API Status 200'
      it_behaves_like 'API Commentable'
      it_behaves_like 'API Attachable'
      it_behaves_like 'API Question attributes'
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'GET /create' do
    it_behaves_like 'API Authenticable'
    it_behaves_like 'API Create object', :question

    def do_request(options = {})
      get '/api/v1/questions', params: { format: :json }.merge(options)
    end
  end
end
