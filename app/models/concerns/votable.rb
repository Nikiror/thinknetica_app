module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote(user, value)
    votes.create!(user: user, value: value, votable: self)
  end

  def vote_reset(user)
    votes.find_by(user: user, votable: self).destroy
  end
end