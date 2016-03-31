FactoryGirl.define do

  sequence(:body) { |n| "Comment #{n} Body" }

  factory :question_comment, class: 'Comment' do
    body
    user
    association :commentable, factory: :question
  end

  factory :answer_comment, class: 'Comment' do
    body
    user
    association :commentable, factory: :answer
  end

  factory :invalid_question_comment, class: 'Comment' do
    body nil
    user
    association :commentable, factory: :question
  end

  factory :invalid_answer_comment, class: 'Comment' do
    body nil
    user
    association :commentable, factory: :answer
  end
end