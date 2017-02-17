# frozen_string_literal: true
require 'rails_helper'

RSpec.describe QuestionSubscriptionJob, type: :job do
  let(:question) { create(:question) }
  let!(:subscriptions) { create_pair(:subscription, question: question) }
  let!(:answer) { create(:answer, question: question) }

  it 'sends new answer to subscriber' do
    question.subscriptions.each do |subscription|
      expect(QuestionMailer).to receive(:question_subscription)
        .with(subscription.user, answer).and_call_original
    end
    QuestionSubscriptionJob.perform_now(question, answer)
  end
end
