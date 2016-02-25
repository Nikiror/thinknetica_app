require_relative '../../acceptance/acceptance_helper'

feature 'Best answer', %q{
  In order to choose the best answer
  As an authenticated user
  I want to be able to choose best answer
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:other_user_question) { create(:question, user: other_user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:second_answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    context 'Author question' do
      before do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'try to choose the best answer', js: true do
        within "#answer-#{answer.id}" do
        click_on 'Make best'
        expect(page).to have_content 'Best answer!'
        expect(page).to_not have_link 'Make best'
        end
      end

      scenario 'try to re-choose the best answer', js: true do
        within "#answer-#{answer.id}" do
          click_on 'Make best'
        end

        within "#answer-#{second_answer.id}" do
          click_on 'Make best'
        end

        within "#answer-#{second_answer.id}" do
          expect(page).to have_content 'Best answer!'
        end

        within "#answer-#{answer.id}" do
          expect(page).to_not have_content 'Best answer!'
          expect(page).to have_link 'Make best'
        end
      end

    end
    context 'Non-author question' do
      before do
        sign_in(user)
        visit question_path(other_user_question)
      end

      scenario 'doesnt see the link for assign the best answer other users question' do
        expect(page).to_not have_link 'Best answer'
      end
    end
  end
      scenario 'Non-authenticated user doesnt see the link for assign the best answer' do
        visit question_path(question)

        within "#answer-#{answer.id}" do
           expect(page).to_not have_link 'Make best'
        end
      end
end
