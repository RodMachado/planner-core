require 'rails_helper'

feature 'Update conference information' do
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
    scenario 'updates and refreshes table', js: true do
      visit '/'
      click_link 'Settings'
      click_link 'Event Setup'
      click_link 'Conference information'
      expect(page).to have_content('Conference Name MyConvention')
      expect(page).to have_content('Event Time Zone Eastern Time (US & Canada)')
      expect(page).to have_content('Conference Start Date 2016-02-01T00:00:00-05:00')
      expect(page).to have_content('Conference Length (Number of Days) 10')
      expect(page).to have_content('Conference Public Start Date 2016-02-03T00:00:00-05:00')
      expect(page).to have_content('Public Number Of Days 5')
      expect(page).to have_content('Time format for publications 24')

      click_button('Edit')
      fill_in('name', with: 'New conference name')
      select('(GMT-03:00) Brasilia', from: 'time_zone')
      within 'div.field-start_date' do
        find(:css, 'input').set('Friday, February 5th 2016')
      end
      fill_in('number_of_days', with: '5')

      within 'div.field-public_start_date' do
        find(:css, 'input').set('Saturday, February 6th 2016')
      end
      fill_in('public_number_of_days', with: '2')
      select('12 hour', from: 'print_time_format')
      click_button 'Save Changes'

      expect(page).to have_content('Conference Name New conference name')
      expect(page).to have_content('Event Time Zone Brasilia')
      expect(page).to have_content('Conference Length (Number of Days) 5')
      expect(page).to have_content('Public Number Of Days 2')
      expect(page).to have_content('Time format for publications 12')
      # expect(page).to have_content('Conference Start Date 2016-02-05T00:00:00-02:00')
      # expect(page).to have_content('Conference Public Start Date 2016-02-06T00:00:00-02:00')
    end
  end
end
