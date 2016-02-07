require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'save the new answer in database' do
        expect { post :create, id: answer, question_id: question, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
      end
      it 'redirect to new view' do
         post :create, id: answer, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question
      end
      it 'should assign user to @answer' do
        post :create, id: answer, question_id: question, answer: attributes_for(:answer)
        expect(Answer.last.user_id).to eq @user.id
      end
      it 'should assign question to @answer' do
        post :create, id: answer, question_id: question, answer: attributes_for(:answer)
        expect(Answer.last.question_id).to eq question.id
      end
    end

   context 'with invalid attributes' do
      it 'dont save the new answer in database' do
        expect { post :create, id: answer, question_id: question, answer: attributes_for(:invalid_answer) }.to_not change(Answer, :count)
      end
      it 're-render new create' do
        post :create, id: answer, question_id: question, answer: attributes_for(:invalid_answer)
        expect(response).to redirect_to question 
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    context 'with valid attributes' do
      it 'assigns requsted answer to @answer' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer)
        expect(assigns(:answer)).to eq answer
      end
      it 'update answer in database' do
        patch :update,  id: answer, question_id: question, answer: { content: 'new content' }
        answer.reload
        expect(answer.content).to eq 'new content'
      end
      it 'redirects to updated answer' do
        patch :update,  id: answer, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question
      end
    end

    context 'with invalid params' do
      it 'dont update answer in database' do
        patch :update,  id: answer, question_id: question, answer: { content: nil }
        answer.reload
        expect(answer.content).to eq answer.content
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      sign_in_user
      context 'Author of answer' do
        let!(:my_answer) { create(:answer, question: question, user: @user) }

        it 'should delete answer from database' do
          expect { delete :destroy, id: my_answer, question_id: my_answer.question }.to change(@user.answers, :count).by(-1)
        end

        it 'redirect to question view' do
          delete :destroy, id: my_answer, question_id: my_answer.question
          expect(response).to redirect_to question
        end
      end

      context 'Non-author of answer' do
        it 'cant delete answer from database' do
          answer
          expect { delete :destroy, id: answer, question_id: answer.question }.to_not change(Answer, :count)
        end
      end
    end
  end
end