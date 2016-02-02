require 'rails_helper'

feature 'Create room' do
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
    scenario 'saves and refreshes rooms table', js: true do
      visit '/'
      click_link 'Venues'
      find('tr', text: 'Venue A').click
      within '#room-control-area' do
        click_button 'Add'
      end
      fill_in('Name', with: 'Room A')
      fill_in('Purpose', with: 'Foo')
      fill_in('Comments', with: 'Bar')
      click_button 'Save Changes'

      within 'table#room-list' do
        expect(page).to have_content('Room A Foo Bar')
      end
    end
  end

  context 'name not filled' do
    scenario 'shows validation error'
  end
end
