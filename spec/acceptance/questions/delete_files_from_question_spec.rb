require_relative '../../acceptance/acceptance_helper'

feature 'Delete files from question', %q{
  In order to delete file
  As an question's author
  I'd like to be able to delete files
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question)  { create(:question, user: user) }
  given!(:attachment) { create(:attachment, attachable: question)}


  scenario 'Question author delete mistake file from question', js: true do
    sign_in(user)
    visit question_path(question)
    within '.question' do
      click_on 'Delete file'
      expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end

  scenario 'Authenticated user try to delete file from question of other user' do
    sign_in(other_user)
    visit question_path(question)
    within '.question' do
      expect(page).to_not have_link 'Delete file'
    end
  end

  scenario 'Non-authenticated user try to delete file from question' do
    visit question_path(question)
    within '.question' do
      expect(page).to_not have_link 'Delete file'
    end
  end
end