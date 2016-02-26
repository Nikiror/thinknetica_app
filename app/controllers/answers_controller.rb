class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create, :update]
  before_action :load_answer, only:[:update, :destroy, :best]


  def create
    @answer  = @question.answers.new(answer_params.merge(user: current_user))
    @answer.save
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
    else
      flash[:alert] = 'You cant delete this answer!'
    end
    redirect_to @answer.question
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
    params.require(:answer).permit(:content)
  end
end