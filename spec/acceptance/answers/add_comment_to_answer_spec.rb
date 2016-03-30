require_relative '../../acceptance/acceptance_helper'

feature 'Add comment to answer', %q{
  In order to clarify answer
  As an authenticate user
  I'd like to be able to comment answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticate user' do
    before do
      sign_in(user)
      visit question_path(question)
      within '.answers' do
        click_on 'Add a comment'
      end
    end

    scenario 'try to comment the answer', js: true do
      within '.answers' do
        within '.new-comment' do
          fill_in 'Body', with: "1234"
          click_on 'Post comment'
        end

        expect(page).to have_content  "1234"
      end
    end

  end

  scenario 'Non-authenticate user try to comment the answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Add a comment'
    end
  end
end