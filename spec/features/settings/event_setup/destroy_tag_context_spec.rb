require 'rails_helper'

feature 'Destroy tag context' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:role) { FactoryGirl.create(:admin_role) }
  let!(:role_assignment) do
    FactoryGirl.create(
      :role_assignment,
      user: user,
      role: role
    )
  end
  let!(:tag_context) { FactoryGirl.create(:tag_context, publish: true) }

  before do
    login_as(user)
  end

  context 'main' do
    scenario 'destroys and refreshes table', js: true do
      visit '/'
      click_link 'Settings'
      click_link 'Event Setup'
      click_link 'Tag Contexts'
      within 'div#config-region-div' do
        expect(page).to have_content('Tag_Context_A Tags Publish')
      end
      find('.model-delete-button').click
      click_button 'Confirm'

      within 'div#config-region-div' do
        expect(page).not_to have_content('Tag_Context_A Tags Publish')
      end
    end
  end
end
