# frozen_string_literal: true
require 'rails_helper'

describe 'Answers API' do
  describe 'GET /index' do
    let!(:question) { create(:question) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json,
                                                                  access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_pair(:answer, question: question) }
      let(:answer) { answers.first }

      before do
        get "/api/v1/questions/#{question.id}/answers",
            params: { format: :json, access_token: access_token.token }
      end

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2)
      end

      %w(id body created_at updated_at question_id).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body)
            .to be_json_eql(answer.send(attr.to_sym).to_json)
            .at_path("0/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}",
            params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:comment) { create(:comment, commentable: answer) }
      let!(:attachment) { create(:attachment, attachable: answer) }

      before do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}",
            params: { format: :json, access_token: access_token.token }
      end

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at question_id).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body)
            .to be_json_eql(answer.send(attr.to_sym).to_json)
            .at_path(attr.to_s)
        end
      end

      context 'comments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path('comments')
        end

        %w(id body created_at updated_at commentable_id commentable_type).each do |attr|
          it "contains #{attr}" do
            expect(response.body)
              .to be_json_eql(comment.send(attr.to_sym).to_json)
              .at_path("comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path('attachments')
        end

        %w(id file created_at updated_at attachable_id attachable_type).each do |attr|
          it "contains #{attr}" do
            expect(response.body)
              .to be_json_eql(attachment.send(attr.to_sym).to_json)
              .at_path("attachments/0/#{attr}")
          end
        end

        it 'contains attachment url' do
          expect(response.body)
            .to be_json_eql(attachment.file.url.to_json)
            .at_path('attachments/0/url')
        end
      end
    end
  end

  describe 'GET /create' do
    let(:question) { create(:question) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json,
                                                                  access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:access_token) { create(:access_token) }

      context 'valid params' do
        it 'returns 201 status code' do
          post "/api/v1/questions/#{question.id}/answers",
               params: { format: :json, access_token: access_token.token,
                         answer: attributes_for(:answer) }
          expect(response.status).to eq(201)
        end

        it 'saves new answer in the database' do
          expect do
            post "/api/v1/questions/#{question.id}/answers",
                 params: { format: :json, access_token: access_token.token,
                           answer: attributes_for(:answer) }
          end.to change(Answer, :count).by(1)
        end
      end

      context 'invalid params' do
        it 'returns 422 status code' do
          post "/api/v1/questions/#{question.id}/answers",
               params: { format: :json, access_token: access_token.token,
                         answer: attributes_for(:invalid_answer) }
          expect(response.status).to eq(422)
        end

        it 'does not save new answer in the database' do
          expect do
            post "/api/v1/questions/#{question.id}/answers",
                 params: { format: :json, access_token: access_token.token,
                           answer: attributes_for(:invalid_answer) }
          end.not_to change(Answer, :count)
        end
      end
    end
  end
end
