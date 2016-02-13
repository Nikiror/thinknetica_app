require_relative '../../acceptance/acceptance_helper'

feature 'User look questions list', %q{
  In order to look questions list with answers
  As an User
  I want to see questions list with answers
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  scenario 'User try to see questions list with answers' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each { |answer| expect(page).to have_content answer.content }
  end
end