# frozen_string_literal: true
FactoryGirl.define do
  factory :attachment do
    # file { fixture_file_upload(Rails.root.join('spec', 'photos', 'test.png'), 'image/png') }
    file { File.new("#{Rails.root}/spec/support/fixtures/image.jpg") }
  end
end
