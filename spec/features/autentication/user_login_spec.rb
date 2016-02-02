require 'rails_helper'

feature 'User Login' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:role) { FactoryGirl.create(:admin_role) }
  let!(:role_assignment) do
    FactoryGirl.create(
      :role_assignment,
      user: user,
      role: role
    )
  end

  scenario 'basic access' do
    visit '/'
    fill_in('user_login', with: 'login')
    fill_in('user_password', with: 'password')
    click_button 'Log In'

    expect(page).to have_content('Signed in successfully.')
  end

  scenario 'wrong password' do
    visit '/'
    fill_in('user_login', with: 'login')
    fill_in('user_password', with: 'badpassword')
    click_button 'Log In'

    expect(page).to have_content('Invalid email or password.')
  end
end
