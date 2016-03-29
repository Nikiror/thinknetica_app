class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:update, :show, :destroy]
  include Voted

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
  end 

  def new
    @question  = Question.new
    @question.attachments.build
  end

  def create

    @question = Question.new(question_params.merge(user: current_user))

    respond_to do |format|
      if @question.save
        format.js do
          PrivatePub.publish_to "/questions", question: @question.to_json
          #render nothing: true
          redirect_to @question
        end
      else
        #format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
        #format.js
      end
    end



#@question = Question.new(question_params.merge(user: current_user))
    #if @question.save

    #  flash[:notice] = 'Your question successfully created.'
    # redirect_to @question
    #else
    #  render :new
   # end
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
    end
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
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end

end
