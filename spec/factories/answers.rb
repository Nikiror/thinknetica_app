FactoryGirl.define do
  sequence :content do |n|
    "My answer#{n}"
  end
  factory :answer do
    content
    question
    user
  end

  factory :invalid_answer, class: "Answer" do
    content nil
    question
    user
  end

end