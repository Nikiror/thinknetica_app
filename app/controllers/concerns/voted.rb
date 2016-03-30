module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_vote, only: [:vote_up, :vote_down, :vote_reset]
  end

  def vote_up
    @votable.vote(current_user, 1) unless current_user.author_of?(@votable)
    render json: { post_id: @votable.id, rating: @votable.votes.rating, voted: true }
  end

  def vote_down
    @votable.vote(current_user, -1) unless current_user.author_of?(@votable)
    render json: { post_id: @votable.id, rating: @votable.votes.rating, voted: true }
  end

  def vote_reset
    @votable.vote_reset(current_user) unless current_user.author_of?(@votable)
    render json: { post_id: @votable.id, rating: @votable.votes.rating, voted: false }
  end

  private

  def model_class
    controller_name.classify.constantize
  end

  def set_vote
    @votable = model_class.find(params[:id])
  end
end