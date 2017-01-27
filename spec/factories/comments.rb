FactoryGirl.define do
  factory :comment do
    body { FFaker::CheesyLingo.sentence }
    user
  end

  factory :invalid_comment, class: Comment do
    body nil
  end
end
