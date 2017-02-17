# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :question_id }
  it do
    subject.user = FactoryGirl.build(:user)
    is_expected.to validate_uniqueness_of(:user_id).scoped_to(:question_id)
  end
end
