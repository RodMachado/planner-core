require 'rails_helper'

feature 'Create datasource' do
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
    scenario 'create datasource and refresh table', js: true do
      visit '/'
      click_link 'Settings'
      click_link 'System Settings'
      click_link 'Data Sources for Importing'
      click_button 'Add Data Source'

      fill_in('name', with: 'New Datasource')
      click_button 'Save Changes'

      expect(page).to have_content('New Datasource')
    end
  end
end
