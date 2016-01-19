class Answer < ActiveRecord::Base
  belongs_to :question, class_name: Question
  validates :content, :question_id, presence: true
end
