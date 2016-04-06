module ControllerMacros
  def sign_in_user
    before do
      @user = create(:user)
      @request.env['device.mapping'] = Devise.mappings[:user]
      sign_in @user
    end
  end
  def sign_in_other_user(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end
end