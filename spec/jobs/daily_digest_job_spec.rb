# frozen_string_literal: true
require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:users) { create_pair(:user) }

  it 'sends daily digest' do
    users.each do |user|
      expect(DailyMailer).to receive(:digest).with(user).and_call_original
    end
    DailyDigestJob.perform_now
  end
end
