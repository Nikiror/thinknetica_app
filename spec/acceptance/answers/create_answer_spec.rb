require_relative '../../acceptance/acceptance_helper'

feature 'Create answers to question', %q{
  In order to help 
  An an authenticated user
  I want to be able to answer the question
 } do
  given(:user) { create(:user) }
  given(:question){ create(:question, user: user) }
  given(:answer){ create(:answer, question: question, user: user) }

  scenario 'Authenticated user creates answer to question', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Content', with: answer.content
    click_on 'Create answer'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content answer.content
    end
  end

  scenario 'Non-authenticated user creates answer' do

    visit question_path(question)

    expect(page).to_not have_content 'Post your Answer'
  end
  scenario "User try to create invalid answer", js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Create answer'
    expect(page).to have_content "Content can't be blank"
  end
end