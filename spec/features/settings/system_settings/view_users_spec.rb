require 'rails_helper'

feature 'View users' do
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
  let!(:role_assignment2) do
    FactoryGirl.create(
      :role_assignment,
      user: user1,
      role: planner_role
    )
  end

  before do
    login_as(user)
  end

  context 'main' do
    scenario 'show users', js: true do
      visit '/'
      click_link 'Settings'
      click_link 'System Settings'
      click_link 'Users'

      expect(page).to have_content('user Admin')
      expect(page).to have_content('user1 Admin, Planner')
    end
  end
end
