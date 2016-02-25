class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create, :new]
  before_action :load_answer, only:[:update, :destroy]


  def create
    @answer  = @question.answers.new(answers_params.merge(user: current_user))
    @answer.save
  end

  def update
    @answer.update(answers_params)
    redirect_to @answer.question
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Your answer successfully deleted.'
    else
      flash[:alert] = 'You cant delete this answer!'
    end
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