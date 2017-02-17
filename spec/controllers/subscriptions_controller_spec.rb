# frozen_string_literal: true
require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:subscription) { create(:subscription, user_id: user.id) }

  sign_in_user(:user)

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new subscription in the database' do
        expect do
          post :create, xhr: true, params: { question_id: question.id,
                                             answer: attributes_for(:answer) }
        end.to change(user.subscriptions, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      before { question.subscriptions << subscription }

      it 'does not save subscription in the database' do
        expect do
          post :create, xhr: true, params: { question_id: question.id }
        end.not_to change(user.subscriptions, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { subscription }

    it 'deletes subscription' do
      expect do
        delete :destroy, xhr: true, params: { id: subscription.id }
      end.to change(Subscription, :count).by(-1)
    end
  end
end
