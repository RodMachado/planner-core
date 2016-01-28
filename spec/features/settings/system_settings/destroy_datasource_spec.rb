require 'rails_helper'

feature 'Destroy datasource' do
  let!(:user) { FactoryGirl.create(:user, login: 'user') }
  let!(:admin_role) { FactoryGirl.create(:admin_role) }
  let!(:role_assignment) do
    FactoryGirl.create(
      :role_assignment,
      user: user,
      role: admin_role
    )
  end

  let!(:datasource) { FactoryGirl.create(:datasource) }

  before do
    login_as(user)
  end

  context 'main' do
    scenario 'destroy datasource and refresh table', js: true do
      visit '/'
      click_link 'Settings'
      click_link 'System Settings'
      click_link 'Data Sources for Importing'
      find('tr', text: 'Datasource A').click
      find('.model-delete-button').click
      click_button 'Confirm'

      expect(page).not_to have_content('Datasource A')
    end
  end
end
