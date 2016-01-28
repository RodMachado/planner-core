require 'rails_helper'

feature 'Destroy format' do
  let!(:user) { FactoryGirl.create(:user, login: 'user') }
  let!(:admin_role) { FactoryGirl.create(:admin_role) }
  let!(:role_assignment) do
    FactoryGirl.create(
      :role_assignment,
      user: user,
      role: admin_role
    )
  end

  let!(:format) { FactoryGirl.create(:format) }

  before do
    login_as(user)
  end

  context 'main' do
    scenario 'destroy format and refresh table', js: true do
      visit '/'
      click_link 'Settings'
      click_link 'System Settings'
      click_link 'Item Formats'
      find('tr', text: 'Format A').click
      find('.model-delete-button').click
      click_button 'Confirm'

      expect(page).not_to have_content('Format A')
    end
  end
end
