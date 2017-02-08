# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  shared_examples 'comment' do |entity|
    before do
      @commentable = public_send(entity)
    end

    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }
    let(:user) { create(:user) }
    let!(:comment) { create(:comment, body: 'MyText', commentable: @commentable, user: user) }

    sign_in_user(:user)

    describe 'GET #new' do
      sign_in_user(:user)

      before do
        get :new, xhr: true, params: { commentable_id => @commentable.id,
                                       commentable: commentable_type }
      end

      it 'assigns a new comment to @comment' do
        expect(assigns(:comment)).to be_a_new(Comment)
      end

      it 'assigns question to commentable' do
        expect(assigns(:commentable)).to eq(@commentable)
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'saves the new comment in the database' do
          expect do
            post :create, xhr: true, params: { commentable_id => @commentable.id,
                                               commentable: commentable_type,
                                               comment: attributes_for(:comment) }
          end.to change(@commentable.comments, :count).by(1)
        end

        it 'render create template' do
          post :create, xhr: true, params: { commentable_id => @commentable.id,
                                             commentable: commentable_type,
                                             comment: attributes_for(:comment) }
          expect(response).to render_template :create
        end
      end
    end

    context 'with invalid attributes' do
      it 'does not save new comment' do
        expect do
          post :create, xhr: true, params: { commentable_id => @commentable.id,
                                             commentable: commentable_type,
                                             comment: attributes_for(:invalid_comment) }
        end.not_to change(Comment, :count)
      end

      it 'render create template' do
        post :create, xhr: true, params: { commentable_id => @commentable.id,
                                           commentable: commentable_type,
                                           comment: attributes_for(:invalid_comment) }
        expect(response).to render_template :create
      end
    end

    describe 'DELETE #destroy' do
      it 'deletes comment' do
        expect do
          delete :destroy, xhr: true, params: { id: comment.id }
        end.to change(Comment, :count).by(-1)
      end
    end
  end

  context 'answer' do
    it_behaves_like 'comment', :answer
  end

  context 'question' do
    it_behaves_like 'comment', :question
  end

  def commentable_id
    "#{commentable_type}_id"
  end

  def commentable_type
    @commentable.class.name.underscore
  end
end
