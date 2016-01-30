class QuestionsController < ApplicationController
  before_action :load_question, only: [:update, :show, :destroy] 
  before_action :authenticate_user!, except: [:index, :show]
  def index
    @questions = Question.all
  end

  def show
  end 

  def new
    @question  = Question.new
  end

  def create 
    @question = Question.new(question_params)
    if @question.save
      flash[:notice] = 'Your question successfully created.'
      redirect_to @question
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
    redirect_to @question
  end

  def destroy
    @question.destroy
    redirect_to questions_path
  end


  private 
  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def authenticate_user
    params.require(:question).permit(:title, :body)
  end

end
