class AnswersController < ApplicationController
  before_action :load_question, only: [:create]
  before_action :load_answer, only:[:update, :destroy]
  before_action :authenticate_user!
  def new
    @answer  = Answer.new
  end

  def create
    @answer  = @question.answers.new(answers_params.merge(user_id: current_user.id))
    if @answer.save
      redirect_to @answer.question
    else
      render :new
    end
  end

  def update
    if @answer.update(answers_params)
      redirect_to @answer.question
    else
      render :new
    end
  end

  def destroy
    @answer.destroy
    redirect_to @answer.question
  end


private
  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answers_params
    params.require(:answer).permit(:content)
  end
end