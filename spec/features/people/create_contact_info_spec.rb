require 'rails_helper'

feature 'Create contact info' do
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
    scenario 'saves and refreshes contact info', js: true do
      visit '/'
      click_link 'People'
      within 'table#participants' do
        find('tr', text: 'Mr Foo Bar Ph.D').click
      end
      within 'ul#participant-tabs' do
        click_link 'Contact Info'
      end
      within 'div#contacts-tab' do
        click_button 'Add Address'
      end
      fill_in('line1', with: 'Address 1')
      fill_in('line2', with: 'Address 2')
      fill_in('line3', with: 'Address 3')
      fill_in('city', with: 'Montreal')
      fill_in('state', with: 'Quebec')
      fill_in('postcode', with: 'a1b 2c3')
      fill_in('country', with: 'Canada')
      check('isdefault')
      click_button 'Save Changes'

      within 'div#contacts-tab' do
        expect(page).to have_content('Default Line 1 Address 1')
        expect(page).to have_content('Line 2 Address 2')
        expect(page).to have_content('Line 3 Address 3')
        expect(page).to have_content('City Montreal')
        expect(page).to have_content('State/Prov./County Quebec')
        expect(page).to have_content('ZIP/Postal Code a1b 2c3')
        expect(page).to have_content('Country Canada')
      end
    end
  end
end
