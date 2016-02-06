require 'rails_helper'

feature 'User sign in', %q{
    In order to be able ask question
    As an User
    I want to be able to sign up
} do
  given(:user) { create(:user) }

  scenario 'User try to sign up' do
    visit new_user_registration_path
    fill_in 'Email', with: 'test@mail.ru'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully'
    expect(current_path).to eq root_path
  end

  scenario 'Registered user try to sign up' do
    visit new_user_registration_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
    expect(current_path).to eq user_registration_path
  end

  scenario 'Signed in user try to sign up' do
    sign_in(user)
    visit new_user_registration_path

    expect(page).to have_content 'You are already signed in'
  end
end