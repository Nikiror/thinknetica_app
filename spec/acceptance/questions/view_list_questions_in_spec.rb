require 'rails_helper'

feature 'User look questions list', %q{
  In order to look full list of questions
  As an User
  I want to see list of questions
} do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3) }

  scenario 'User try to see list of questions' do
    sign_in(user)
    visit questions_path

    questions.each { |question| expect(page).to have_content question.title }
  end
end