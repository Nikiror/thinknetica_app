class AnswersController < ApplicationController
	before_action :load_question, only: [:create, :destroy, :update]
	before_action :load_answer, only:[:update, :destroy]

	def create
		@answer  = @question.answers.create(answers_params)
	end

	def update
		@answer.update(answers_params)
 		redirect_to @answer.question
	end

	def destroy
		@answer.destroy
		redirect_to @question
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