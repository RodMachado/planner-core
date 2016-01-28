require 'rails_helper'

feature 'Update user' do
  let!(:user) { FactoryGirl.create(:user, login: 'user') }
  let!(:admin_role) { FactoryGirl.create(:admin_role) }
  let!(:planner_role) { FactoryGirl.create(:planner_role) }
  let!(:role_assignment) do
    FactoryGirl.create(
      :role_assignment,
      user: user,
      role: admin_role
    )
  end

  let!(:user1) { FactoryGirl.create(:user, login: 'user1', email: 'foo1@bar.com') }

  before do
    login_as(user)
  end

  context 'main' do
    scenario 'update user and refresh table', js: true do
      visit '/'
      click_link 'Settings'
      click_link 'System Settings'
      click_link 'Users'
      find('tr', text: 'user1').click

      click_button 'Edit'
      within('#modal-body') do
        fill_in('login', with: 'new_user')
        fill_in('email', with: 'new_user@email.com')
        fill_in('password', with: '12345678')
        fill_in('password_confirmation', with: '12345678')
        click_button 'Add'
      end
      within('div.field-id') do
        select('Planner', from: 'Role to Add')
      end
      click_button 'OK'
      click_button 'Save Changes'

      expect(page).to have_content('user Admin')
      expect(page).to have_content('new_user Planner')
    end
  end
end
