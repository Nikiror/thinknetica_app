require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }

  describe 'POST #create' do
    context "authenticated user" do
      sign_in_user
      context 'with valid attributes' do
        it 'save the new answer in database' do
          expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js }.to change(question.answers, :count).by(1)
        end
        it 'render create template' do
           post :create, question_id: question, answer: attributes_for(:answer), format: :js
          expect(response).to render_template :create
        end
        it 'should assign user to @answer' do
            expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js }.to change(@user.answers, :count).by(1)
        end
      end
      context 'with invalid attributes' do
        it 'dont save the new answer in database' do
          expect { post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js }.to_not change(question.answers, :count)
        end
      end
    end
    context 'unauthenticated user' do
      it 'should redirect to sign in page' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    context 'with authenticated user' do
      context 'Author of answer' do
        sign_in_user
        let(:answer) { create(:answer, user: @user, question: question) }
        context 'with valid attributes' do
          it 'assigns requsted answer to @answer' do
            patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
            expect(assigns(:answer)).to eq answer
          end
          it 'assigns question' do
            patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
            expect(assigns(:question)).to eq question
          end
          it 'update answer in database' do
            patch :update,  id: answer.id, question_id: question, answer: { content: 'new content' }, format: :js
            answer.reload
            expect(answer.content).to eq 'new content'
          end
        end

        context 'with invalid params' do
          it 'dont update answer in database' do
            patch :update,  id: answer, question_id: question, answer: { content: nil }, format: :js
            answer.reload
            expect(answer.content).to eq answer.content
          end
          it 'render template with error' do
            patch :update, id: answer, question_id: question, user: @user, answer: { content: '' }, format: :js
            expect(response).to render_template :update
          end
        end
      end
      context 'Non-author of answer' do
        sign_in_user
        let(:another_answer) { create(:answer, question: question) }
        it 'update answer in database' do
          patch :update, id: another_answer.id, question_id: question, answer: { content: 'Edited content' }, format: :js
          another_answer.reload
          expect(another_answer.content).to eq another_answer.content
        end
      end
    end

    context 'with unauthenticated user' do
      let!(:another_answer2) { create(:answer, question: question) }

      it 'should not update answer in DB' do
        patch :update, id: another_answer2, question_id: question, answer: { content: 'Edited content' }, format: :js
        another_answer2.reload
        expect(another_answer2.content).to eq another_answer2.content
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      sign_in_user
      let!(:answer2) { create(:answer, question: question) }
      context 'Author of answer' do
        let!(:my_answer) { create(:answer, question: question, user: @user) }

        it 'should delete answer from database' do
          expect { delete :destroy, id: my_answer, question_id: my_answer.question, format: :js }.to change(@user.answers, :count).by(-1)
        end

        #it 'redirect to question view' do
         # delete :destroy, id: my_answer, question_id: my_answer.question, format: :js
        #  expect(response).to redirect_to question
       # end
      end

      context 'Non-author of answer' do

        it 'cant delete answer from database' do
          expect { delete :destroy, id: answer2, question_id: answer2.question, format: :js }.to_not change(Answer, :count)
        end
      end
    end
  end

  describe 'POST :best' do

    let!(:another_question) { create(:question) }

    let!(:second_another_answer) { create(:answer, question: another_question) }

    context 'with authenticated user' do
      sign_in_user
      let!(:my_question) { create(:question, user: @user) }
      let!(:my_answer) { create(:answer, user: @user, question: my_question) }
      let!(:another_answer) { create(:answer, question: my_question) }
      context 'authors question' do
        it 'should make answer as best' do
          post :best, id: my_answer, question_id: my_question, format: :js
          my_answer.reload
          expect(my_answer.best?).to be_truthy
        end
      end
      context 'in another users question' do
        it 'should not make answer as best' do
          post :best, id: second_another_answer, question_id: another_question, format: :js
          second_another_answer.reload
          expect(second_another_answer.best?).to be_falsey
        end
      end
      context 'best answer is choosed' do
        before do
          another_answer.make_best
          post :best, id: my_answer, question_id: my_question, format: :js
        end

        it 'should set all other answers as not best' do
          another_answer.reload
          expect(another_answer.best?).to be_falsey
        end

        it 'should set checked answer as best' do
          my_answer.reload
          expect(my_answer.best?).to be_truthy
        end
      end
    end
    context 'with unauthenticated user' do

      it 'should not make answer as best' do
        post :best, id: second_another_answer, question_id: another_question, format: :js
        second_another_answer.reload
        expect(second_another_answer.best?).to_not be_truthy
      end
    end
  end
end