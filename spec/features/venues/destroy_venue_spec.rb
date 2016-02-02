require 'rails_helper'

feature 'Destroy venue' do
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
    scenario 'destroys and refreshes venues table', js: true do
      visit '/'
      click_link 'Venues'
      find('tr', text: 'Venue A').click
      within '#venue-control-area' do
        click_button 'Delete'
      end
      click_button 'Confirm'

      within 'table#venue-list' do
        expect(page).not_to have_content('Venue A')
      end
    end
  end

  context 'with associated rooms' do
    let!(:room) { FactoryGirl.create(:room, venue: venue) }

    scenario 'shows validation error', js: true do
      visit '/'
      click_link 'Venues'
      find('tr', text: 'Venue A').click
      within '#venue-control-area' do
        click_button 'Delete'
      end
      click_button 'Confirm'

      expect(page).to have_content('Can not delete venue that has rooms')
      within 'table#venue-list' do
        expect(page).to have_content('Venue A')
      end
    end
  end
end
