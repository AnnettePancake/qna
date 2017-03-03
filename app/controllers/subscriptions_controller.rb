# frozen_string_literal: true
class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  load_resource :question
  load_and_authorize_resource :subscription, through: :question, shallow: true

  respond_to :js

  def create
    @subscription = current_user.subscriptions.create(question_id: @question.id)
    render :toggle_subscription
  end

  def destroy
    @question = @subscription.question
    @subscription.destroy
    render :toggle_subscription
  end
end
