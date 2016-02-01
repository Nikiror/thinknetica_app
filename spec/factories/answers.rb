FactoryGirl.define do
  factory :answer do
    content "My answer"
    question
    user
  end

   factory :invalid_answer, class: "Answer" do
    content nil
    question
    user
  end

end
