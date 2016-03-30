require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer) }
  let(:question_comment) { create(:question_comment) }
  let(:answer_comment) { create(:answer_comment) }
  let(:invalid_question_comment) { create(:invalid_question_comment) }
  let(:invalid_answer_comment) { create(:invalid_answer_comment) }

  describe 'POST #create' do
    sign_in_user

    context 'question' do
      it 'saves the new comment to question in the database' do
        expect { post :create, question_id: question, comment: attributes_for(:question_comment), commentable: 'questions', format: :js }.to change(question.comments, :count).by(1)
      end

      it 'render create template' do
        post :create, question_id: question, comment: attributes_for(:question_comment), commentable: 'questions', format: :js
        expect(response).to render_template :create
      end

      it 'comment to question with invalid body not save in the DB' do
        expect { post :create, question_id: question, comment: attributes_for(:invalid_question_comment), commentable: 'questions', format: :js }.to_not change(question.comments, :count)
      end
    end

    context 'answer' do
      it 'saves comment to answer in the DB' do
        expect { post :create, answer_id: answer, comment: attributes_for(:answer_comment), commentable: 'answers', format: :js }.to change(answer.comments, :count).by(1)
      end

      it 'render create template' do
        post :create, answer_id: answer, comment: attributes_for(:answer_comment), commentable: 'answers', format: :js
        expect(response).to render_template :create
      end

      it 'comment to answer with invalid body not save in the DB' do
        expect { post :create, answer_id: answer, comment: attributes_for(:invalid_answer_comment), commentable: 'answers', format: :js }.to_not change(question.comments, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let!(:another_question_comment) { create(:question_comment, commentable: question) }
    let!(:another_answer_comment) { create(:answer_comment, commentable: answer) }

    context 'question' do
      let!(:question_comment) { create(:question_comment, commentable: question, user: @user) }

      context 'comment author' do
        it 'delete comment' do
          expect { delete :destroy, id: question_comment, format: :js }.to change(Comment, :count).by(-1)
        end

        it 'render destroy template' do
          delete :destroy, id: question_comment, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'non-comment author' do
        it 'delete comment' do
          expect { delete :destroy, id: another_question_comment, format: :js }.to_not change(Answer, :count)
        end
      end
    end

    context 'answer' do
      let!(:answer_comment) { create(:answer_comment, commentable: answer, user: @user) }

      context 'comment author' do
        it 'delete comment' do
          expect { delete :destroy, id: answer_comment, format: :js }.to change(Comment, :count).by(-1)
        end

        it 'render destroy template' do
          delete :destroy, id: answer_comment, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'non-comment author' do
        it 'delete comment' do
          expect { delete :destroy, id: another_answer_comment, format: :js }.to_not change(Answer, :count)
        end
      end
    end
  end
end
