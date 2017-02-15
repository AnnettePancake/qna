# frozen_string_literal: true
class QuestionSubscriptionJob < ActiveJob::Base
  queue_as :default

  def perform(question, answer)
    question.subscriptions.each do |subscription|
      QuestionMailer.question_subscription(subscription.user, answer).deliver_later
    end
  end
end
