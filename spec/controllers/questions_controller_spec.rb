require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
let(:question) { question = create(:question) }
  describe "GET #index" do
    let(:questions) { questions = create_list(:question,2) }
    
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

    it 'renders show new' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'save the new question in database' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
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
    sign_in_user
    context 'with valid attributes' do
      it 'assigns requsted question to @question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, id: question, question: { title: "new title", body: "new body" }
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to updated question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not change question attributes' do
        patch :update, id: question, question: { title: "new title", body: nil }
        question.reload
        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
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
          question
          expect { delete :destroy, id: question }.to_not change(@user.questions, :count)
        end
      end
    end
  end
end
