# frozen_string_literal: true
require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  let(:answer) { create(:answer, body: 'MyText', question: question, user: user) }

  sign_in_user(:user)

  describe 'GET #edit' do
    before { get :edit, params: { question_id: question.id, id: answer.id } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect do
          post :create, params: { question_id: question.id, answer: attributes_for(:answer),
                                  format: :js }
        end.to change(question.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer),
                                format: :js }
        expect(response).to render_template :create
      end
    end
  end

  context 'with invalid attributes' do
    it 'does not save new answer' do
      expect do
        post :create, params: { question_id: question.id, answer: attributes_for(:invalid_answer),
                                format: :js }
      end.not_to change(Answer, :count)
    end

    it 'render create template' do
      post :create, params: { question_id: question.id, answer: attributes_for(:invalid_answer),
                              format: :js }
      expect(response).to render_template :create
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'assigns the requested answer to @answer' do
        patch :update, params: { question_id: question.id, id: answer,
                                 answer: attributes_for(:answer), format: :js }
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { question_id: question.id, id: answer,
                                 answer: { body: 'new body' }, format: :js }
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update template' do
        patch :update, params: { question_id: question.id, id: answer,
                                 answer: attributes_for(:answer), format: :js }

        expect(response).to render_template :update
      end
    end
  end

  context 'with invalid attributes' do
    before do
      patch :update, params: { question_id: question.id, id: answer,
        answer: attributes_for(:invalid_answer), format: :js }
    end

    it 'does not change answer attributes' do
      answer.reload
      expect(answer.body).to eq 'MyText'
    end

    it 'renders update template' do
      expect(response).to render_template :update
    end
  end

  describe 'DELETE #destroy' do
    before { answer }

    it 'deletes answer' do
      expect do
        delete :destroy, params: { id: answer.id, question_id: question.id }
      end.to change(Answer, :count).by(-1)
    end

    it 'redirect to' do
      delete :destroy, params: { id: answer.id, question_id: question.id, format: :js }
      expect(response).to redirect_to question_path(id: question.id)
    end
  end
end
