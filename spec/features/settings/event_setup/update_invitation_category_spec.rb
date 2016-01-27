require 'rails_helper'

feature 'Update invitation category' do
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
    scenario 'updates and refreshes table', js: true do
      visit '/'
      click_link 'Settings'
      click_link 'Event Setup'
      click_link 'Invitation Categories'
      find('.model-edit-button').click
      fill_in('name', with: 'Invitation Category B')
      click_button 'Save Changes'

      within 'div#config-region-div' do
        expect(page).to have_content('Invitation Category B')
      end
    end
  end
end
