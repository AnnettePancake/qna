# frozen_string_literal: true
require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'GET #new' do
    before { get :new, params: { question_id: question.id } }

    it 'assigns to a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { question_id: question.id, id: answer } }

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
          post :create, params: { question_id: question.id, answer: attributes_for(:answer) }
        end.to change(Answer, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(id: question.id)
      end
    end
  end

  context 'with invalid attributes' do
    it 'does not save new answer' do
      expect do
        post :create, params: { question_id: question.id, answer: attributes_for(:invalid_answer) }
      end.not_to change(Answer, :count)
    end

    it 're-renders new view' do
      post :create, params: { question_id: question.id, answer: attributes_for(:invalid_answer) }
      expect(response).to render_template :new
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'assigns the requested answer to @answer' do
        patch :update, params: { question_id: question.id, id: answer,
                                 answer: attributes_for(:answer) }
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { question_id: question.id, id: answer,
                                 answer: { body: 'new body' } }
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'redirects to the updated answer' do
        patch :update, params: { question_id: question.id, id: answer,
                                 answer: attributes_for(:answer) }

        expect(response).to redirect_to question_path(id: question.id)
      end
    end
  end

  context 'with invalid attributes' do
    before do
      patch :update, params: { question_id: question.id, id: answer, answer: { body: nil } }
    end

    it 'does not change answer attributes' do
      answer.reload
      expect(answer.body).to eq 'MyText'
    end

    it 're-renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'DELETE #destroy' do
    before { answer }

    it 'deletes answer' do
      expect do
        delete :destroy, params: { id: answer, question_id: question.id }
      end.to change(Answer, :count).by(-1)
    end

    it 'redirect to' do
      delete :destroy, params: { id: answer, question_id: question.id }
      expect(response).to redirect_to question_path(id: question.id)
    end
  end
end
