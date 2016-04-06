class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:update, :show, :destroy]
  before_action :load_answer, only: :show
  before_action :publish_questiom, only: :create
  include Voted
  respond_to :html, :json, :js

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end 

  def new
    respond_with(@question  = Question.new)
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    @question.destroy
    respond_with(@question)
  end

  private

  def load_answer
    @answer = @question.answers.build
  end

  def load_question
    @question = Question.find(params[:id])
  end
  def publish_questiom
    PrivatePub.publish_to('/questions', question: @question.to_json)
  end
  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end

end
