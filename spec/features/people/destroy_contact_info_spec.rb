require 'rails_helper'

feature 'Update contact info' do
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
  let!(:postal_address) { FactoryGirl.create(:postal_address) }
  let!(:address) do
    FactoryGirl.create(
      :address,
      addressable: postal_address,
      person: person
    )
  end

  before do
    login_as(user)
  end

  context 'main' do
    scenario 'updates and refreshes contact info', js: true do
      visit '/'
      click_link 'People'
      within 'table#participants' do
        find('tr', text: 'Mr Foo Bar Ph.D').click
      end
      within 'ul#participant-tabs' do
        click_link 'Contact Info'
      end
      within 'div.contact-details-div' do
        find('.model-delete-button').click
      end
      click_button 'Confirm'

      within 'div#contacts-tab' do
        expect(page).not_to have_content('Line 1 Address 1')
        expect(page).not_to have_content('Line 2 Address 2')
        expect(page).not_to have_content('Line 3 Address 3')
        expect(page).not_to have_content('City Montreal')
        expect(page).not_to have_content('State/Prov./County Quebec')
        expect(page).not_to have_content('ZIP/Postal Code a1b 2c3')
        expect(page).not_to have_content('Country Canada')
      end
    end
  end
end
