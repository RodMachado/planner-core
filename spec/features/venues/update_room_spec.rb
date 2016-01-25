require 'rails_helper'

feature 'Update room' do
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
    scenario 'updates and refreshes rooms table', js: true do
      visit '/'
      click_link 'Venues'
      find('tr', text: 'Venue A').click
      find('tr', text: 'Room A').click
      within '#room-control-area' do
        click_button 'Edit'
      end
      fill_in('Name', with: 'Room B')
      fill_in('Purpose', with: 'Foo')
      fill_in('Comments', with: 'Bar')
      click_button 'Save Changes'

      within 'table#room-list' do
        expect(page).to have_content('Room B Foo Bar')
      end
    end
  end

  context 'name not filled' do
    scenario 'shows validation error'
  end
end
