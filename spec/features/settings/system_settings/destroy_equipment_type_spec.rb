require 'rails_helper'

feature 'Destroy equipment type' do
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
    scenario 'destroy equipment type and refresh table', js: true do
      visit '/'
      click_link 'Settings'
      click_link 'System Settings'
      click_link 'Equipment'
      find('tr', text: 'Equipment Type A').click
      find('.model-delete-button').click
      click_button 'Confirm'

      expect(page).not_to have_content('Equipment Type A')
    end
  end
end
