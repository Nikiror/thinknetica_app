require_relative '../../acceptance/acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I want to be able to attach file
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end
  scenario 'User adds file when asks question' do
    fill_in 'Title', with: "question title"
    fill_in 'Text', with: 'question text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    expect(page).to have_link "spec_helper.rb", href:"/uploads/attachment/file/1/spec_helper.rb"
  end
end