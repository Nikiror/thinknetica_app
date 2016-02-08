require 'rails_helper'

feature 'Delete question', %q{
  As an authenticated user
  I want to be able to delete his question and answers 
} do        
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question){ create(:question, user: user) }
  given!(:other_question){ create(:question, user: other_user) }

  scenario 'Authenticated user delete his question and answers' do
    sign_in(user)

    visit question_path(question)
    click_on 'Delete question'
 
    expect(page).to have_content 'Your question successfully deleted.'
    expect(current_path).to eq questions_path
    expect(page).to_not have_content question.title
  end

  scenario 'Authenticated user try to delete other user question' do
    sign_in(user)

    visit question_path(other_question)
 
    expect(page).to_not have_content 'Delete question'
  end

end