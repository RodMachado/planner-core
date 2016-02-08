require 'rails_helper'

feature 'Update equipment type' do
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
    scenario 'update equipment type and refresh table', js: true do
      visit '/'
      click_link 'Settings'
      click_link 'System Settings'
      click_link 'Equipment'
      find('tr', text: 'Equipment Type A').click
      find('.model-edit-button').click
      fill_in('description', with: 'Updated Equipment Type')
      click_button 'Save Changes'

      expect(page).to have_content('Updated Equipment Type')
    end
  end
end
