# frozen_string_literal: true
require 'ffaker'

FactoryGirl.define do
  factory :answer do
    body { FFaker::CheesyLingo.sentence }
    question
    user
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end
