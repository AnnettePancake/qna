# frozen_string_literal: true
require 'ffaker'

FactoryGirl.define do
  factory :question do
    title { FFaker::CheesyLingo.title }
    body { FFaker::CheesyLingo.sentence }
    user
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
