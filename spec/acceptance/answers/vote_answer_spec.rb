require_relative '../../acceptance/acceptance_helper'

feature 'Vote for answer', %q{
  In order to select favourite answer
  As an authenticated user
  I want to be able to vote for answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:user_answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)

      within "#answer-#{answer.id}" do
        click_link 'Vote up'
      end
    end

    scenario 'try to vote for answer', js: true do
      within "#answer-#{answer.id}" do
        expect(page).to_not have_link 'Vote up'
        expect(page).to_not have_link 'Vote down'
        expect(page).to have_link 'Vote delete'
      end
      within ".answer-vote-area .rating" do
        expect(page).to have_content '1'
      end
    end

    scenario 'try to vote up for answer, but later vote down', js: true do
      within "#answer-#{answer.id}" do
        click_link 'Delete'
        click_link 'Down'

        expect(page).to_not have_link 'Vote up'
        expect(page).to_not have_link 'Vote down'
        expect(page).to have_link 'Vote delete'
      end
      within ".answer-vote-area .rating" do
        expect(page).to have_content '-1'
      end
    end
  end

  scenario 'Author try to vote for his answer' do
    sign_in(user)
    visit question_path(question)

    within "#answer-#{user_answer.id}" do
      expect(page).to_not have_link 'Vote up'
      expect(page).to_not have_link 'Vote down'
    end
  end

  scenario 'Non-autenticated user try to vote for answer' do
    visit question_path(question)

    within '.answer' do
      expect(page).to_not have_link 'Vote up'
      expect(page).to_not have_link 'Vote down'
    end
  end
end