FactoryGirl.define do
  factory :question do
    title "Myquestiontitle"
    body "Myquestion"
    user
  end
  factory :invalid_question, class: "Question" do
    title nil
    body nil
    user
  end
end
