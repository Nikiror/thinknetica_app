require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }

  describe 'GET #new' do
   before {get :new, question_id: question}
    it 'assign a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show new' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
   context 'with valid attributes' do
      it 'save the new answer in database' do
        expect { post :create, id: answer, question_id: question, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
      end
      it 'assign @answer to question' do
        post :create, id: answer, question_id: question, answer: attributes_for(:answer)
        expect(assigns(:answer).question_id).to eq answer.question_id 
      end
      it 'redirect to new view' do
         post :create, id: answer, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question
      end
   end

   context 'with invalid attributes' do
      it 'dont save the new answer in database' do
        expect { post :create, id: answer, question_id: question, answer: attributes_for(:invalid_answer) }.to_not change(Answer, :count)
      end
      it 're-render new create' do
        post :create, id: answer, question_id: question, answer: attributes_for(:invalid_answer)
        expect(response).to render_template :new 
      end
   end
  end

  describe 'PATCH #update' do
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
    it 'should delete answer from database' do
      expect { delete :destroy, id: answer, question_id: question }.to change(question.answers, :count).by(-1)
    end

    it 'redirect to question view' do
      delete :destroy, id: answer, question_id: question
      expect(response).to redirect_to question_path
    end
  end
end
