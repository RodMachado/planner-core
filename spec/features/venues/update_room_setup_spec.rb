require 'rails_helper'

feature 'Update room setup' do
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
  let!(:setup_type_alt) { FactoryGirl.create(:setup_type, name: 'Other Setup Type') }
  let!(:venue) { FactoryGirl.create(:venue) }
  let!(:room) { FactoryGirl.create(:room, venue: venue) }
  let!(:room_setup) do
    FactoryGirl.create(:room_setup, room: room, setup_type: setup_type)
  end

  before do
    login_as(user)
  end

  context 'main' do
    scenario 'updates and refreshes room setups table', js: true do
      visit '/'
      click_link 'Venues'
      find('tr', text: 'Venue A').click
      find('tr', text: 'Room A').click
      find('.model-edit-button').click
      select('Other Setup Type', from: 'Setup Type')
      fill_in('Capacity', with: '75')
      check('Default')
      click_button 'Save Changes'

      within 'div#room-setup-region-div' do
        expect(page).to have_content('Default')
        expect(page).to have_content('Room Setup Other Setup Type')
        expect(page).to have_content('Capacity 75')
      end
    end
  end
end
