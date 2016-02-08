require 'rails_helper'

feature 'Update setup_type' do
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
    scenario 'update setup_type and refresh table', js: true do
      visit '/'
      click_link 'Settings'
      click_link 'System Settings'
      click_link 'Room Setups'
      find('tr', text: 'Setup Type A').click
      find('.model-edit-button').click
      fill_in('name', with: 'Updated Setup Type')
      click_button 'Save Changes'

      expect(page).to have_content('Updated Setup Type')
    end
  end
end
