require_relative '../../acceptance/acceptance_helper'

feature 'Delete answer', %q{
  As an authenticated user
  I want to be able to delete his answers
} do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question){ create(:question, user: user) }
  given!(:answer){ create(:answer, question: question, user: user) }


  scenario 'Unauthenticated user try to delete answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Delete'
    end
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees link to delete answer' do

      within '.answers' do
        expect(page).to have_link 'Delete'
      end
    end

    scenario 'try to delete his answer', js: true do
      within ".answers" do
        click_on 'Delete'
        expect(page).to_not have_content answer.content
      end
    end
  end
  describe 'Non-author' do
    before do
      sign_in(other_user)
      visit question_path(question)
    end
    scenario 'try to delete answer of other user' do
      within "#answer-#{answer.id}" do
        expect(page).to_not have_link 'Delete'
      end
    end
  end

  describe 'Non-author and author answer' do
    given!(:other_answer) { create(:answer, question: question, user: other_user) }

    before do
      sign_in(other_user)
      visit question_path(question)
    end

    scenario 'sees link to delete his answer, but doesnt see delete link to other users answer' do
      within "#answer-#{answer.id}" do
        expect(page).to_not have_link 'Delete'
      end

      within "#answer-#{other_answer.id}" do
        expect(page).to have_link 'Delete'
      end
    end
  end
end