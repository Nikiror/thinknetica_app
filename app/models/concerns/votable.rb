module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end
  def rating
    votes.select('coalesce(sum(CASE value WHEN 1 THEN 1 ELSE -1 END),0) as rating').take.rating
  end
  def vote(user, value)
    votes.create(user: user, value: value)
  end

  def vote_reset(user)
    votes.where(user: user, votable: self).destroy
  end
end