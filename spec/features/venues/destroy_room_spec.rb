require 'rails_helper'

feature 'Destroy room' do
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
  let!(:room) { FactoryGirl.create(:room, venue: venue) }

  before do
    login_as(user)
  end

  context 'main' do
    scenario 'destroys and refreshes rooms table', js: true do
      visit '/'
      click_link 'Venues'
      find('tr', text: 'Venue A').click
      find('tr', text: 'Room A').click
      within '#room-control-area' do
        click_button 'Delete'
      end
      click_button 'Confirm'

      within 'table#room-list' do
        expect(page).not_to have_content('Room A')
      end
    end
  end
end
