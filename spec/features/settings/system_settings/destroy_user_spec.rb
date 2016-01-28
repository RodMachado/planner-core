require 'rails_helper'

feature 'Destroy user' do
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
  let!(:role_assignment1) do
    FactoryGirl.create(
      :role_assignment,
      user: user1,
      role: admin_role
    )
  end

  before do
    login_as(user)
  end

  context 'main' do
    scenario 'destroy user and refresh table', js: true do
      visit '/'
      click_link 'Settings'
      click_link 'System Settings'
      click_link 'Users'
      find('tr', text: 'user1').click

      click_button 'Delete'
      click_button 'Confirm'

      expect(page).not_to have_content('new_user')
    end
  end
end
