# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:votes) }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
end
