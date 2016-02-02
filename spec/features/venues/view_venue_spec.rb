require 'rails_helper'

feature 'View venue' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:role) { FactoryGirl.create(:admin_role) }
  let!(:role_assignment) do
    FactoryGirl.create(
      :role_assignment,
      user: user,
      role: role
    )
  end
  let!(:venue1) { FactoryGirl.create(:venue) }
  let!(:room1) { FactoryGirl.create(:room, venue: venue1) }

  let!(:venue2) { FactoryGirl.create(:venue, name: 'Venue B') }
  let!(:room2) { FactoryGirl.create(:room, name: 'Room B', venue: venue2) }

  before do
    login_as(user)
  end

  context 'main' do
    scenario 'show rooms when venue is selected', js: true do
      visit '/'
      click_link 'Venues'
      find('tr', text: 'Venue A').click
      within '#room-list' do
        expect(page).to have_content('Room A')
      end

      within '#venue-list' do
        find('tr', text: 'Venue B').click
      end
      within '#room-list' do
        expect(page).to have_content('Room B')
      end
    end
  end
end
