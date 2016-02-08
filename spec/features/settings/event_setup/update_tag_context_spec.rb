require 'rails_helper'

feature 'Update tag context' do
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
    scenario 'updates and refreshes table', js: true do
      visit '/'
      click_link 'Settings'
      click_link 'Event Setup'
      click_link 'Tag Contexts'
      within 'div#config-region-div' do
        expect(page).to have_content('Tag_Context_A Tags Publish')
      end
      find('.model-edit-button').click
      fill_in('name', with: 'Tag Context B')
      uncheck('publish')
      click_button 'Save Changes'

      within 'div#config-region-div' do
        expect(page).to have_content('Tag_Context_B Tags Not Published')
      end
    end
  end
end
