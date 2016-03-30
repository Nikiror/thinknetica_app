require_relative '../../acceptance/acceptance_helper'

feature 'Vote for question', %q{
  In order to select favourite question
  As an authenticated user
  I want to be able to vote for question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:user_question) { create(:question, user: user) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)

    end

    scenario 'try to vote for question', js: true do
      within ".question-vote-area" do
        click_link 'Vote up'

        expect(page).to_not have_link 'Vote up'
        expect(page).to_not have_link 'Vote down'
        expect(page).to have_link 'Vote delete'
      end
        within ".question-vote-area .rating" do
          expect(page).to have_content '1'
        end
    end

    scenario 'try to vote up for question, but vote down later', js: true do
      within ".question-vote-area" do
      click_link 'Vote delete'
      click_link 'Vote down'

      expect(page).to_not have_link 'Vote up'
      expect(page).to_not have_link 'Vote down'
      expect(page).to have_link 'Vote delete'
      end
      within ".question-vote-area .rating" do
        expect(page).to have_content '-1'
      end
    end
  end

  scenario 'Author try to vote for his question' do
    sign_in(user)
    visit question_path(user_question)
    within ".question-vote-area" do
      expect(page).to_not have_link 'Vote up'
      expect(page).to_not have_link 'Vote down'
      expect(page).to_not have_link 'Vote delete'
    end
  end

  scenario 'Non-authenticated user try to vote for question' do
    visit question_path(question)
    within ".question-vote-area" do
      expect(page).to_not have_link 'Vote up'
      expect(page).to_not have_link 'Vote down'
      expect(page).to_not have_link 'Vote delete'
    end
  end
end