require 'rails_helper'

feature 'View formats' do
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
    scenario 'show formats', js: true do
      visit '/'
      click_link 'Settings'
      click_link 'System Settings'
      click_link 'Item Formats'

      expect(page).to have_content('Format A')
    end
  end
end
