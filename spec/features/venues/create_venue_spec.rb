require 'rails_helper'

feature 'Create venue' do
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
    scenario 'saves and refreshes venues table', js: true do
      visit '/'
      click_link 'Venues'
      click_button 'Add'
      fill_in('Name', with: 'Venue A')
      click_button 'Save Changes'

      within 'table#venue-list' do
        expect(page).to have_content('Venue A')
      end
    end
  end

  context 'name not filled' do
    scenario 'shows validation error', js: true do
      visit '/'
      click_link 'Venues'
      click_button 'Add'
      click_button 'Save Changes'

      within 'div.field-name' do
        expect(page).to have_content('Required')
      end
    end
  end
end
