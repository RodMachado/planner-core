require 'rails_helper'

feature 'Create availability' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:role) { FactoryGirl.create(:admin_role) }
  let!(:role_assignment) do
    FactoryGirl.create(
      :role_assignment,
      user: user,
      role: role
    )
  end
  let!(:invitation_category) { FactoryGirl.create(:invitation_category) }
  let!(:person) do
    FactoryGirl.create(
      :person,
      invitation_category: invitation_category
    )
  end

  before do
    login_as(user)
  end

  context 'main' do
    scenario 'saves and refreshes availability', js: true do
      visit '/'
      click_link 'People'
      within 'table#participants' do
        find('tr', text: 'Mr Foo Bar Ph.D').click
      end
      within 'ul#participant-tabs' do
        click_link 'Availability'
      end
      within 'div#availability-tab' do
        find('.model-new-button').click
      end
      within 'div.field-start_time' do
        find(:css, 'input').set('01 Feb 2016, 00:00')
      end
      within 'div.field-end_time' do
        find(:css, 'input').set('05 Feb 2016, 00:00')
      end

      click_button 'Save Changes'

      within 'div#availability-tab' do
        expect(page).to have_content('Arrival: Monday, February 1 2016,12:00 AM')
        expect(page).to have_content('Departure: Friday, February 5 2016,12:00 AM')
      end
    end
  end
end
