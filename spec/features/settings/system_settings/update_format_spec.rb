require 'rails_helper'

feature 'Update format' do
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
    scenario 'update format and refresh table', js: true do
      visit '/'
      click_link 'Settings'
      click_link 'System Settings'
      click_link 'Item Format'
      find('tr', text: 'Format A').click
      find('.model-edit-button').click
      fill_in('name', with: 'Updated Format')
      click_button 'Save Changes'

      expect(page).to have_content('Updated Format')
    end
  end
end
