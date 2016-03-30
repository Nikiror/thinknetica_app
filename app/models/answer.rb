class Answer < ActiveRecord::Base
  include Votable
  include Commentable
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable
  validates :content, :question_id, :user_id, presence: true
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
  default_scope { order(best: :desc) }
  def make_best
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
