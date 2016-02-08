require 'rails_helper'

feature 'Create invitation category' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:role) { FactoryGirl.create(:admin_role) }
  let!(:role_assignment) do
    FactoryGirl.create(
      :role_assignment,
      user: user,
      role: role
    )
  end

  before do
    login_as(user)
  end

  context 'main' do
    scenario 'saves and refreshes table', js: true do
      visit '/'
      click_link 'Settings'
      click_link 'Event Setup'
      click_link 'Invitation Categories'
      click_button 'Add Invitation Category'
      fill_in('name', with: 'Invitation Category A')
      click_button 'Save Changes'

      within 'div#config-region-div' do
        expect(page).to have_content('Invitation Category A')
      end
    end
  end
end
