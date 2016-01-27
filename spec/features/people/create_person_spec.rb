require 'rails_helper'

feature 'Create person' do
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

  before do
    login_as(user)
  end

  context 'main' do
    scenario 'saves and refreshes people table', js: true do
      visit '/'
      click_link 'People'
      within 'div#participant-control' do
        click_button 'Add'
      end
      fill_in('prefix', with: 'Mr')
      fill_in('first_name', with: 'Foo')
      fill_in('last_name', with: 'Bar')
      fill_in('suffix', with: 'Ph.D')
      fill_in('company', with: 'Grenadine')
      fill_in('job_title', with: 'Developer')
      within 'div#modal-body' do
        select('Invitation Category A', from: 'invitation_category_id')
        select('Invited', from: 'invitestatus_id')
        select('Accepted', from: 'acceptance_status_id')
        fill_in('comments', with: 'Some comments')
      end
      click_button 'Save Changes'

      within 'table#participants' do
        expect(page).to have_content('Mr Foo Bar Ph.D Invited Invitation Category A Accepted')
      end
    end
  end
end
