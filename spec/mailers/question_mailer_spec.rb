# frozen_string_literal: true
require 'rails_helper'

RSpec.describe QuestionMailer, type: :mailer do
  describe 'question_subscription' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer) }
    let(:mail) { QuestionMailer.question_subscription(user, answer) }

    it 'renders the headers' do
      expect(mail.subject).to eq('New answer for subscribed question')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['support@qna.local'])
    end

    it 'mail contains body of answer' do
      expect(mail.body.encoded).to include(answer.body)
    end
  end
end
