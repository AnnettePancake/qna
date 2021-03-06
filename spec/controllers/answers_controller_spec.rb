# frozen_string_literal: true
require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'votes' do
    let(:voteable) { create(:answer) }
  end

  let(:question) { create(:question) }
  let(:user) { create(:user) }
  let(:answer) { create(:answer, body: 'MyText', question: question, user: user) }

  sign_in_user(:user)

  describe 'GET #edit' do
    before { get :edit, xhr: true, params: { id: answer.id, question_id: question.id } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders edit template' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect do
          post :create, xhr: true, params: { question_id: question.id,
                                             answer: attributes_for(:answer) }
        end.to change(question.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, xhr: true, params: { question_id: question.id,
                                           answer: attributes_for(:answer) }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save new answer' do
        expect do
          post :create, xhr: true, params: { question_id: question.id,
                                             answer: attributes_for(:invalid_answer) }
        end.not_to change(Answer, :count)
      end

      it 'render create template' do
        post :create, xhr: true, params: { question_id: question.id,
                                           answer: attributes_for(:invalid_answer) }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'assigns the requested answer to @answer' do
        patch :update, xhr: true, params: { id: answer, answer: attributes_for(:answer) }
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, xhr: true, params: { id: answer, answer: { body: 'new body' } }
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update template' do
        patch :update, xhr: true, params: { id: answer, answer: attributes_for(:answer) }

        expect(response).to render_template :update
      end
    end
  end

  context 'with invalid attributes' do
    before do
      patch :update, xhr: true, params: { id: answer, answer: attributes_for(:invalid_answer) }
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
        delete :destroy, xhr: true, params: { id: answer.id }
      end.to change(Answer, :count).by(-1)
    end
  end

  describe 'POST #toggle_best' do
    let(:question) { create(:question, user: user) }
    let(:another_answer) { create(:answer, body: 'MyText2', best: false) }

    it 'toggles best answer if current user is author of question' do
      post :toggle_best, xhr: true, params: { id: answer.id }
      expect(answer.reload.best).to be_truthy
    end

    it 'toggles best answer if current user is author of question' do
      post :toggle_best, xhr: true, params: { id: another_answer.id }
      expect(another_answer.reload.best).to be_falsey
    end
  end
end
