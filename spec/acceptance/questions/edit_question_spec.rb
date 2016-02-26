require_relative '../../acceptance/acceptance_helper'

feature 'Question editing', %q{
  In order to fix mistake
  As an author
  I want to be able to edit my question
} do
  given(:other_user) { create(:user) }
  given(:user) { create(:user) }
  given!(:question){ create(:question, user: user) }

  scenario 'Unauthenticated user try to edit question' do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees link to edit question' do

      within '.question' do
        expect(page).to have_link 'Edit'

      end
    end

    scenario 'try to edit his question', js: true do
      within '.question' do
        click_on 'Edit'
        fill_in 'Title', with: 'Edit t question'
        fill_in 'Text', with: 'edit text question'
        click_on 'Save'
      end
        expect(page).to_not have_content question.body
        expect(page).to have_content 'Edit t question'
        expect(page).to have_content 'edit text question'
        expect(page).to_not have_selector '.edit-question'
    end
  end

  describe 'Non-author' do
    before do
      sign_in(other_user)
      visit question_path(question)
    end

    scenario 'try to edit answer of other user' do
      within '.question' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end