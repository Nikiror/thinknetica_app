class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:update, :show, :destroy] 
  def index
    @questions = Question.all
  end

  def show
  end 

  def new
    @question  = Question.new
  end

  def create 
    @question = Question.new(question_params.merge(user: current_user))
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
    if current_user.author_of?(@question)
      @question.destroy
      flash[:notice] = 'Your question successfully deleted.'
    else
      flash[:alert] = 'You cant delete this question!'
    end
    redirect_to questions_path
  end

  private 
  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

end
