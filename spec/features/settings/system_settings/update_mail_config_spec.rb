require 'rails_helper'

feature 'Update mail_config' do
  let!(:user) { FactoryGirl.create(:user, login: 'user') }
  let!(:admin_role) { FactoryGirl.create(:admin_role) }
  let!(:role_assignment) do
    FactoryGirl.create(
      :role_assignment,
      user: user,
      role: admin_role
    )
  end

  let!(:mail_config) { FactoryGirl.create(:mail_config) }

  before do
    login_as(user)
  end

  context 'main' do
    scenario 'update mail_config', js: true do
      visit '/'
      click_link 'Settings'
      click_link 'System Settings'
      click_link 'Email addresses'
      find('.model-edit-button').click

      fill_in('info', with: 'info@mail.com')
      fill_in('reply_to', with: 'reply@mail.com')
      fill_in('cc', with: 'cc@mail.com')
      fill_in('test_email', with: 'test@mail.com')
      click_button 'Save Changes'

      expect(page).to have_content('Info Email info@mail.com')
      expect(page).to have_content('Reply-To email reply@mail.com')
      expect(page).to have_content('cc Email cc@mail.com')
      expect(page).to have_content('Test Email test@mail.com')
    end
  end
end
