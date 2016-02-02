require 'rails_helper'

feature 'Update venue' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:role) { FactoryGirl.create(:admin_role) }
  let!(:role_assignment) do
    FactoryGirl.create(
      :role_assignment,
      user: user,
      role: role
    )
  end
  let!(:venue) { FactoryGirl.create(:venue) }

  before do
    login_as(user)
  end

  context 'main' do
    scenario 'updates and refreshes venues table', js: true do
      visit '/'
      click_link 'Venues'
      find('tr', text: 'Venue A').click
      within '#venue-control-area' do
        click_button 'Edit'
      end
      fill_in('Name', with: 'Venue B')
      click_button 'Save Changes'

      within 'table#venue-list' do
        expect(page).to have_content('Venue B')
      end
    end
  end

  context 'name not filled' do
    scenario 'shows validation error', js: true do
      visit '/'
      click_link 'Venues'
      find('tr', text: 'Venue A').click
      within '#venue-control-area' do
        click_button 'Edit'
      end
      fill_in('Name', with: '')
      click_button 'Save Changes'

      within 'div.field-name' do
        expect(page).to have_content('Required')
      end
    end
  end
end
