require_relative '../../acceptance/acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I want to be able to attach file
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when answer', js: true do
    fill_in 'Content', with: "test answer 1923"
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create answer'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end

  scenario 'User adds files when answer', js: true do
    fill_in 'Content', with: "345643654"

    click_on 'Add file'

    page.all(:file_field, 'File').first.set("#{Rails.root}/spec/spec_helper.rb")
    page.all(:file_field, 'File').last.set("#{Rails.root}/spec/rails_helper.rb")
    $stdin.gets
    click_on 'Create answer'

    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/2/spec_helper.rb'
  end
end