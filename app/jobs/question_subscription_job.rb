# frozen_string_literal: true
class QuestionSubscriptionJob < ActiveJob::Base
  queue_as :default

  def perform(question, answer)
    question.subscribers.find_each do |user|
      QuestionMailer.question_subscription(user, answer).deliver_later
    end
  end
end
