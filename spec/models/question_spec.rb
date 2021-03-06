# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should belong_to(:user) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }

  it { should accept_nested_attributes_for :attachments }

  describe 'Subscribe author for question update' do
    let(:user) { create(:user) }
    let(:question) { build(:question, user: user) }

    it 'subscribes author' do
      expect { question.save }.to change(user.subscriptions, :count).by(1)
    end
  end
end
