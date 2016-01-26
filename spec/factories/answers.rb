FactoryGirl.define do
  factory :answer do
    content "My text"
    question
  end

   factory :invalid_answer, class: "Answer" do
    content nil
    question
  end

end
