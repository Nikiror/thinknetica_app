#require 'rails_helper'
require_relative 'concerns/voted'
RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe "GET #index" do
    let(:questions) { create_list(:question,2) }
    before { get :index }
    it 'download all questions to array' do
      expect(assigns(:questions)).to match_array(questions)
    end
    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    before { get :show, id: question }
    it 'assigns requsted question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new Answer to question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe "GET #new" do
    sign_in_user

    before {get :new}

    it 'assign a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end
    it 'builds new attachments to Question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end
    it 'renders show new' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'save the new question in database' do
        expect { post :create, question: attributes_for(:question) }.to change(@user.questions, :count).by(1)
      end
      it 'redirect to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'dont save the new question in database' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end
      it 're-renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context "with authenticated user" do
      sign_in_user
    let!(:another_question) { create(:question, user: @user) }
      context "Author" do
        context 'with valid attributes' do
          it 'assigns requsted question to @question' do
            patch :update, id: question, question: attributes_for(:question), format: :js
            expect(assigns(:question)).to eq question
          end

          it 'changes question attributes' do
            patch :update, id: another_question, question: { title: "new title", body: "new body" }, format: :js
            another_question.reload
            expect(another_question.title).to eq 'new title'
            expect(another_question.body).to eq 'new body'
          end
        end

        context 'with invalid attributes' do
          it 'does not change question attributes' do
            patch :update, id: another_question, question: { title: "new title", body: nil }, format: :js
            another_question.reload
            expect(another_question.title).to eq another_question.title
            expect(another_question.body).to eq another_question.body
          end
        end
      end
      context "Non-author" do
        it 'not changes question attributes' do
          patch :update, id: question, question: { title: "new title", body: "new body" }, format: :js
          question.reload
          expect(question.title).to eq question.title
          expect(question.body).to eq question.body
        end

      end
    end
    context 'with unauthenticated user' do
      it 'should redirect to sign in' do
        post :create
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      sign_in_user
      before { question }

      context 'Author of answer' do
        let!(:my_question) { create(:question, user: @user) }

        it 'delete question' do
          expect { delete :destroy, id: my_question }.to change(@user.questions, :count).by(-1)
        end

        it 'redirect to index view' do
          delete :destroy, id: my_question
          expect(response).to redirect_to questions_path
        end
      end

       context 'Non-author of answer' do
        it 'cant delete question' do
          expect { delete :destroy, id: question }.to_not change(Question, :count)
        end
      end
    end
  end

  it_behaves_like 'voted'
end
