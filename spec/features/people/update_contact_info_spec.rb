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
        find('.model-edit-button').click
      end
      fill_in('line1', with: 'New Address 1')
      fill_in('line2', with: 'New Address 2')
      fill_in('line3', with: 'New Address 3')
      fill_in('city', with: 'Los Angeles')
      fill_in('state', with: 'California')
      fill_in('postcode', with: '90028')
      fill_in('country', with: 'USA')
      click_button 'Save Changes'

      within 'div#contacts-tab' do
        expect(page).to have_content('Line 1 New Address 1')
        expect(page).to have_content('Line 2 New Address 2')
        expect(page).to have_content('Line 3 New Address 3')
        expect(page).to have_content('City Los Angeles')
        expect(page).to have_content('State/Prov./County California')
        expect(page).to have_content('ZIP/Postal Code 90028')
        expect(page).to have_content('Country USA')
      end
    end
  end
end
