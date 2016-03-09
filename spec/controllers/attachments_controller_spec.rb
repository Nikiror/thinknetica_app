require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:another_question) { create(:question, user: other_user) }

  describe 'DELETE #destroy' do
    sign_in_user


    let!(:question_attachment) { create(:attachment, attachable: question) }
    let!(:another_question_attachment) { create(:attachment, attachable: another_question) }
    let!(:answer_attachment) { create(:attachment, attachable: question) }
    let!(:another_answer_attachment) { create(:attachment, attachable: another_question) }

    context 'Author' do
      let(:question) { create(:question, user: @user) }

      context 'answer' do
        it 'delete file from answer' do
          expect { delete :destroy, id: answer_attachment, format: :js }.to change(Attachment, :count).by(-1)
        end

        it 'render answer' do
          delete :destroy, id: answer_attachment, format: :js
          expect(response).to render_template :destroy
        end
      end
    end
    context 'Non-author' do
      it 'delete file from question' do
        expect { delete :destroy, id: another_question_attachment, format: :js }.to_not change(Attachment, :count)
      end

      it 'delete file from answer' do
        expect { delete :destroy, id: another_answer_attachment, format: :js }.to_not change(Attachment, :count)
      end
    end
  end
end