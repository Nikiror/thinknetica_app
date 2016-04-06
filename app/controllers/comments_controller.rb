class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: :create
  before_action :load_comment, only: :destroy
  respond_to :js
  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge!(user_id: current_user.id)))
  end

  def destroy
    respond_with(@comment.destroy)
  end
  private

  def load_commentable
    @commentable = Question.find(params[:question_id]) if params[:question_id]
    @commentable = Answer.find(params[:answer_id]) if params[:answer_id]
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def load_comment
    @comment = Comment.find(params[:id])
  end
end