require 'rails_helper'

feature 'Create room setup' do
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
  let!(:venue) { FactoryGirl.create(:venue) }
  let!(:room) { FactoryGirl.create(:room, venue: venue) }

  before do
    login_as(user)
  end

  context 'main' do
    scenario 'creates and refreshes room setups table', js: true do
      visit '/'
      click_link 'Venues'
      find('tr', text: 'Venue A').click
      find('tr', text: 'Room A').click
      click_button 'Add room setup'
      select('Setup Type A', from: 'Setup Type')
      fill_in('Capacity', with: '100')
      check('Default')
      click_button 'Save Changes'

      within 'div#room-setup-region-div' do
        expect(page).to have_content('Default')
        expect(page).to have_content('Room Setup Setup Type A')
        expect(page).to have_content('Capacity 100')
      end
    end
  end
end
