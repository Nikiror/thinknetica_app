require_relative '../../acceptance/acceptance_helper'

feature 'Delete files from answer', %q{
  In order to delete file
  As an answer's author
  I'd like to be able to delete files
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer){ create(:answer, question: question, user: user) }
  given!(:attachment) { create(:attachment, attachable: answer) }

  scenario 'Answer author delete mistake file from answer', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete file'

    expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'Authenticated user try to delete mistake file from answer' do
    sign_in(other_user)
    visit question_path(question)
    within '.attachment' do
      expect(page).to_not have_link 'Delete file'
    end
  end

  scenario 'Non-authenticated user try to delete mistake file from answer' do
    visit question_path(question)
    within '.attachment' do
      expect(page).to_not have_link 'Delete file'
    end
  end
end