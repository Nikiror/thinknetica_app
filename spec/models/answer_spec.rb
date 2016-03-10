require 'rails_helper'

RSpec.describe Answer, type: :model do
   it { should validate_presence_of :content }
   it { should validate_presence_of :question_id }
   it { should belong_to :question }
   it { should belong_to :user }
   it { should have_many :attachments }
   it { should accept_nested_attributes_for :attachments}


   context "best answer" do
     let!(:question) { create :question }
     let!(:answer) { create :answer, question_id: question.id }
     let!(:another_answer) { create :answer, question_id: question.id, best: true }

     it 'sets current answer as best' do
       answer.make_best
       answer.reload
       expect(answer.best?).to be_truthy
     end

     it 'sets all other answers in question to false' do
       answer.make_best
       another_answer.reload
       expect(another_answer.best?).to be_falsey
     end
   end
end
