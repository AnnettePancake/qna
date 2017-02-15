# frozen_string_literal: true
require 'rails_helper'

describe 'Answers API' do
  describe 'GET /index' do
    let!(:question) { create(:question) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_pair(:answer, question: question) }
      let(:answer) { answers.first }
      let(:answer_path) { '0/' }

      before do
        get "/api/v1/questions/#{question.id}/answers",
            params: { format: :json, access_token: access_token.token }
      end

      it_behaves_like 'API Status 200'
      it_behaves_like 'API List'
      it_behaves_like 'API Answer attributes'
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }
    let!(:comment) { create(:comment, commentable: answer) }
    let!(:attachment) { create(:attachment, attachable: answer) }
    let(:answer_path) { '' }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}",
            params: { format: :json, access_token: access_token.token }
      end

      it_behaves_like 'API Commentable'
      it_behaves_like 'API Attachable'
      it_behaves_like 'API Status 200'
      it_behaves_like 'API Answer attributes'
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers/#{answer.id}",
          params: { format: :json }.merge(options)
    end
  end

  describe 'GET /create' do
    let(:question) { create(:question) }
    let(:path) { "#{question.id}/answers" }

    it_behaves_like 'API Authenticable'
    it_behaves_like 'API Create object', :answer

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end
end
