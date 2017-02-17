# frozen_string_literal: true
require 'rails_helper'

RSpec.describe DailyMailer, type: :mailer do
  describe 'digest' do
    let(:user) { create(:user) }
    let(:questions) { create_pair(:question, created_at: Date.yesterday) }
    let(:mail) { DailyMailer.digest(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Daily digest of questions')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['support@qna.local'])
    end

    it 'mail contains titles of questions' do
      questions.each do |question|
        expect(mail.body.encoded).to include(question.title)
      end
    end
  end
end
