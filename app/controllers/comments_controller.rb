class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: :create
  before_action :load_comment, only: :destroy
  def create
    @comment = @commentable.comments.new(comment_params.merge(user: current_user))
    @comment.save
  end
  def destroy
    if current_user.author_of?(@comment)
      @comment.destroy
    else
      flash[:alert] = 'You cant delete this comment!'
    end
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