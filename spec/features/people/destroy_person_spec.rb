require 'rails_helper'

feature 'Destroy person' do
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
    scenario 'destroys and refreshes people table', js: true do
      visit '/'
      click_link 'People'
      within 'table#participants' do
        find('tr', text: 'Mr Foo Bar Ph.D').click
      end
      within 'div#participant-control' do
        click_button 'Delete'
      end
      click_button 'Confirm'

      within 'table#participants' do
        expect(page).not_to have_content('Mr Foo Bar Ph.D Invitation Category A')
      end
    end
  end
end
