require 'rails_helper'

feature 'View equipments' do
  let!(:user) { FactoryGirl.create(:user, login: 'user') }
  let!(:admin_role) { FactoryGirl.create(:admin_role) }
  let!(:role_assignment) do
    FactoryGirl.create(
      :role_assignment,
      user: user,
      role: admin_role
    )
  end

  let!(:equipment_type) { FactoryGirl.create(:equipment_type) }

  before do
    login_as(user)
  end

  context 'main' do
    scenario 'show equipments', js: true do
      visit '/'
      click_link 'Settings'
      click_link 'System Settings'
      click_link 'Users'

      expect(page).to have_content('user Admin')
      expect(page).to have_content('user1 Admin, Planner')
    end
  end
end
