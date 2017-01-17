# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:voteable) }
  it { should belong_to(:user) }
end
