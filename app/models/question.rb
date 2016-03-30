class Question < ActiveRecord::Base
  include Votable
  include Commentable
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable
  belongs_to :user

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
  validates :title, :body, :user_id, presence: true
end
