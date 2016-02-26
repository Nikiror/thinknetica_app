class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  validates :content, :question_id, :user_id, presence: true

  default_scope { order(best: :desc) }

  def make_best
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
