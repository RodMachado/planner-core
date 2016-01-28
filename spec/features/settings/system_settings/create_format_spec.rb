require 'rails_helper'

feature 'Create format' do
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
    scenario 'create format and refresh table', js: true do
      visit '/'
      click_link 'Settings'
      click_link 'System Settings'
      click_link 'Item Formats'
      click_button 'Add Item Format'

      fill_in('name', with: 'New Format')
      click_button 'Save Changes'

      expect(page).to have_content('New Format')
    end
  end
end
