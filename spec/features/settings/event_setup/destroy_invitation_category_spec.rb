require 'rails_helper'

feature 'Destroy invitation category' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:role) { FactoryGirl.create(:admin_role) }
  let!(:role_assignment) do
    FactoryGirl.create(
      :role_assignment,
      user: user,
      role: role
    )
  end
  let!(:invitation_category) { FactoryGirl.create(:invitation_category) }

  before do
    login_as(user)
  end

  context 'main' do
    scenario 'destroys and refreshes table', js: true do
      visit '/'
      click_link 'Settings'
      click_link 'Event Setup'
      click_link 'Invitation Categories'
      within 'div#config-region-div' do
        expect(page).to have_content('Invitation Category A')
      end
      find('.model-delete-button').click
      click_button 'Confirm'
      within 'div#config-region-div' do
        expect(page).not_to have_content('Invitation Category A')
      end
    end
  end
end
