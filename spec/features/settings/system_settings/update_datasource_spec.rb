require 'rails_helper'

feature 'Update datasource' do
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
    scenario 'update datasource and refresh table', js: true do
      visit '/'
      click_link 'Settings'
      click_link 'System Settings'
      click_link 'Data Sources for Importing'
      find('tr', text: 'Datasource A').click
      find('.model-edit-button').click
      fill_in('name', with: 'Updated Datasource')
      click_button 'Save Changes'

      expect(page).to have_content('Updated Datasource')
    end
  end
end
