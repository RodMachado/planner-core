require 'rails_helper'

feature 'View setup types' do
  let!(:user) { FactoryGirl.create(:user, login: 'user') }
  let!(:admin_role) { FactoryGirl.create(:admin_role) }
  let!(:role_assignment) do
    FactoryGirl.create(
      :role_assignment,
      user: user,
      role: admin_role
    )
  end

  let!(:setup_type) { FactoryGirl.create(:setup_type) }

  before do
    login_as(user)
  end

  context 'main' do
    scenario 'show setup types', js: true do
      visit '/'
      click_link 'Settings'
      click_link 'System Settings'
      click_link 'Room Setups'

      expect(page).to have_content('Setup Type A')
    end
  end
end
