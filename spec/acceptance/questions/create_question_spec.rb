require_relative '../../acceptance/acceptance_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask question
} do        
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user creates question' do
    sign_in(user)

    visit questions_path 

    click_on 'Ask question'
    fill_in 'Title', with: question.title
    fill_in 'Text', with: question.body
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content question.title
    expect(page).to have_content question.body

  end

scenario 'Non-authenticated user creates question' do

    visit questions_path 
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end