require_relative '../../acceptance/acceptance_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author
  I want to be able to edit my answer
} do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question){ create(:question, user: user) }
  given!(:answer){ create(:answer, question: question, user: user) }


  scenario 'Unauthenticated user try to edit answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees link to edit answer' do

      within '.answers' do
        expect(page).to have_link 'Edit'

      end
    end
    scenario 'try to edit his answer', js: true do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Answer', with: 'edit answer'
        click_on 'Save'
        expect(page).to_not have_content answer.content
        expect(page).to have_content 'edit answer'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end
  describe 'Non-author' do
    before do
      sign_in(other_user)
      visit question_path(question)
    end
    scenario 'try to edit answer of other user' do
      within '.answers' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end

  describe 'Non-author and author answer' do
    given!(:other_answer) { create(:answer, question: question, user: other_user) }

    before do
      sign_in(other_user)
      visit question_path(question)
    end

    scenario 'sees link to edit his answer, but doesnt see edit link to other users answer' do
      within "#answer-#{answer.id}" do
        expect(page).to_not have_link 'Edit'
      end

      within "#answer-#{other_answer.id}" do
        expect(page).to have_link 'Edit'
      end
    end
  end
end