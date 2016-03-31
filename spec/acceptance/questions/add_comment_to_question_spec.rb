require_relative '../../acceptance/acceptance_helper'

feature 'Add comment to question', %q{
  In order to clarify question
  As an authenticate user
  I'd like to be able to comment question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:comment) { build(:question_comment) }

  describe 'Authenticate user' do
    before do
      sign_in(user)
      visit question_path(question)
      click_on 'Add a comment'
    end

    scenario 'try to comment the question', js: true do
      within '.new-comment' do
        fill_in 'Body', with:  "1234"
        click_on 'Post comment'
      end

        expect(page).to have_content  "1234"
    end

  end

  scenario 'Non-authenticate user try to comment the question' do
    visit question_path(question)

    expect(page).to_not have_link 'Add a comment'
  end
end