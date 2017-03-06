# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question).touch(true) }
  it { should belong_to(:user) }

  it { should have_many(:attachments).dependent(:destroy) }

  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }

  it { should accept_nested_attributes_for :attachments }
end
