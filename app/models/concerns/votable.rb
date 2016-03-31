module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end
  def rating
   votes.sum(:value)
  end
  def vote(user, value)
    votes.create(user: user, value: value)
  end

  def vote_reset(user)
    votes.where(user: user, votable: self).destroy
  end
end
