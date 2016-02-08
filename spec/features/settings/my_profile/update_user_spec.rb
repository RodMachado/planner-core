require 'rails_helper'

feature 'Update user' do
  let!(:user) { FactoryGirl.create(:user, login: 'user') }
  let!(:admin_role) { FactoryGirl.create(:admin_role) }
  let!(:role_assignment) do
    FactoryGirl.create(
      :role_assignment,
      user: user,
      role: admin_role
    )
  end

  before do
    login_as(user)
  end

  context 'main' do
    scenario 'update user', js: true do
      visit '/'
      click_link 'Settings'
      click_link 'My Profile'

      fill_in('user_email', with: 'new@mail.com')
      fill_in('user_password', with: 'newpassword')
      fill_in('user_password_confirmation', with: 'newpassword')
      fill_in('user_current_password', with: 'password')
      click_button 'Update'

      expect(page).to have_content('You updated your account successfully.')
    end
  end

  context 'with wrong password confirmation' do
    scenario 'alerts error', js: true do
      pending
      visit '/'
      click_link 'Settings'
      click_link 'My Profile'

      fill_in('user_password', with: 'newpassword')
      fill_in('user_password_confirmation', with: '')
      fill_in('user_current_password', with: 'password')
      click_button 'Update'

      expect(page).to have_content(%q{password doesn't match confirmation})
    end
  end

  context 'with wrong current password' do
    scenario 'alerts error', js: true do
      pending
      visit '/'
      click_link 'Settings'
      click_link 'My Profile'

      fill_in('user_email', with: 'new@mail.com')
      fill_in('user_password', with: 'newpassword')
      fill_in('user_password_confirmation', with: 'newpassword')
      fill_in('user_current_password', with: 'badpass')
      click_button 'Update'

      expect(page).to have_content('current password is invalid')
    end
  end

  context 'with invalid email' do
    scenario 'alerts error'
  end
end
