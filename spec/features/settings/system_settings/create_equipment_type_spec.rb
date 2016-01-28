require 'rails_helper'

feature 'Create equipment type' do
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
    scenario 'create equipment type and refresh table', js: true do
      visit '/'
      click_link 'Settings'
      click_link 'System Settings'
      click_link 'Equipment'
      click_button 'Add Equipment Type'

      fill_in('description', with: 'New Equipment Type')
      click_button 'Save Changes'

      expect(page).to have_content('New Equipment Type')
    end
  end
end
