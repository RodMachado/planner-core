require 'rails_helper'

feature 'View equipment types' do
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
    scenario 'show equipment types', js: true do
      visit '/'
      click_link 'Settings'
      click_link 'System Settings'
      click_link 'Equipment'

      expect(page).to have_content('Equipment Type A')
    end
  end
end
