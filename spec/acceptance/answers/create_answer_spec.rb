require 'rails_helper'

feature 'Create answers to question', %q{
  In order to help 
  An an authenticated user
  I want to be able to answer the question
 } do
  given(:user) { create(:user) }
  given!(:question){ create(:question, user: user) }

  scenario 'Authenticated user creates answer to question' do
    sign_in(user)
    visit question_path(question)

    
    fill_in 'Content', with: "Test answer"
    click_on 'Create answer'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Your answer successfully created.'
  end

  scenario 'Non-authenticated user creates answer' do

    visit question_path(question)

    expect(page).to_not have_content 'Post your Answer'
  end
end