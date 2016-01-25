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
  let!(:setup_type) { FactoryGirl.create(:setup_type) }
  let!(:setup_type2) { FactoryGirl.create(:setup_type, name: 'Setup Type B') }
  let!(:venue) { FactoryGirl.create(:venue) }
  let!(:room1) { FactoryGirl.create(:room, venue: venue) }
  let!(:room1_setup) do
    FactoryGirl.create(:room_setup, room: room1, setup_type: setup_type)
  end
  let!(:room2) { FactoryGirl.create(:room, name: 'Room B', venue: venue) }
  let!(:room2_setup) do
    FactoryGirl.create(:room_setup, room: room2, setup_type: setup_type2, capacity: 30)
  end

  before do
    login_as(user)
  end

  context 'main' do
    scenario 'show rooms when venue is selected', js: true do
      visit '/'
      click_link 'Venues'
      find('tr', text: 'Venue A').click
      within '#room-list' do
        find('tr', text: 'Room A').click
      end
      within 'div#room-setup-region-div' do
        expect(page).not_to have_content('Default')
        expect(page).to have_content('Room Setup Setup Type A')
        expect(page).to have_content('Capacity 50')
      end

      within '#room-list' do
        find('tr', text: 'Room B').click
      end
      within 'div#room-setup-region-div' do
        expect(page).not_to have_content('Default')
        expect(page).to have_content('Room Setup Setup Type B')
        expect(page).to have_content('Capacity 30')
      end
    end
  end
end
