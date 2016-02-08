require 'rails_helper'

feature 'Update person' do
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
  let!(:invitation_category2) do
    FactoryGirl.create(:invitation_category, name: 'Invitation Category B')
  end
  let!(:person) do
    FactoryGirl.create(
      :person,
      invitation_category: invitation_category
    )
  end
  let!(:person_con_state) do
    FactoryGirl.create(
      :person_con_state,
      person: person,
      invitestatus: InviteStatus.find(5),
      acceptance_status: AcceptanceStatus.find(8)
    )
  end

  before do
    login_as(user)
  end

  context 'main' do
    scenario 'updates and refreshes people table', js: true do
      visit '/'
      click_link 'People'
      within 'table#participants' do
        find('tr', text: 'Mr Foo Bar Ph.D').click
      end
      within 'div#participant-control' do
        click_button 'Edit'
      end
      fill_in('prefix', with: 'Ms')
      fill_in('first_name', with: 'Bar')
      fill_in('last_name', with: 'Foo')
      fill_in('suffix', with: 'M.D')
      fill_in('company', with: 'Company B')
      fill_in('job_title', with: 'Doctor')
      within 'div#modal-body' do
        select('Invitation Category B', from: 'invitation_category_id')
        select('Invite Pending', from: 'invitestatus_id')
        select('Declined', from: 'acceptance_status_id')
        fill_in('comments', with: 'Some other comments')
      end
      click_button 'Save Changes'

      within 'table#participants' do
        expect(page).to have_content('Ms Bar Foo M.D Invite pending Invitation Category B Declined')
      end
    end
  end
end
