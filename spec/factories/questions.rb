FactoryGirl.define do
  sequence :title do |n|
    "questiontitle#{n}"
  end
  factory :question do
    title 
    body "Myquestion"
    user
  end
  factory :invalid_question, class: "Question" do
    title nil
    body nil
    user
  end

end
