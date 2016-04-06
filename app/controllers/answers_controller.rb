class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create, :update]
  before_action :load_answer, only:[:update, :destroy, :best]
  include Voted
  respond_to :js

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge!(user_id: current_user.id)))
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def destroy
    @question = @answer.question
    respond_with(@answer.destroy)
  end

  def best
    @question = @answer.question
    if current_user.author_of?(@question) && !@answer.best?
      @answer.make_best
      flash[:notice] = "This answer choose as best!"
    end
  end

private
  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
  def answer_params
    params.require(:answer).permit(:content, attachments_attributes: [:id, :file, :_destroy])
  end
end