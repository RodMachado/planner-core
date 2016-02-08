require 'rails_helper'

feature 'Update published info' do
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
  let!(:edited_bio) { FactoryGirl.create(:edited_bio, person: person) }

  before do
    login_as(user)
  end

  context 'main' do
    scenario 'updates and refreshes published info', js: true do
      visit '/'
      click_link 'People'
      within 'table#participants' do
        find('tr', text: 'Mr Foo Bar Ph.D').click
      end
      within 'ul#participant-tabs' do
        click_link 'Published Info'
      end
      within 'div#bio-region-div' do
        find('.model-edit-button').click
      end
      fill_in_ckeditor('bio', with: 'Some MORE bio info')
      fill_in('website', with: 'newwebsite.com')
      fill_in('twitterinfo', with: 'twitter.com/newme')
      fill_in('othersocialmedia', with: 'other.com/newme')
      fill_in('facebook', with: 'facebook.com/newme')
      fill_in('photourl', with: 'photo.com/newme.jpg')
      click_button 'Save Changes'

      within 'div#bio-region-div' do
        expect(page).to have_content('Bio (edited) Some MORE bio info')
        expect(page).to have_content('Photo (URL) photo.com/newme.jpg')
        expect(page).to have_content('Web Site newwebsite.com')
        expect(page).to have_content('Twitter twitter.com/newme')
        expect(page).to have_content('Facebook facebook.com/newme')
        expect(page).to have_content('Other Social Media URL other.com/newme')
      end
    end
  end

  context 'missing fields' do
    scenario 'saves and refreshes published info', js: true do
      visit '/'
      click_link 'People'
      within 'table#participants' do
        find('tr', text: 'Mr Foo Bar Ph.D').click
      end
      within 'ul#participant-tabs' do
        click_link 'Published Info'
      end
      within 'div#bio-region-div' do
        find('.model-edit-button').click
      end
      fill_in_ckeditor('bio', with: 'Some MORE bio info')
      fill_in('website', with: '')
      fill_in('twitterinfo', with: '')
      fill_in('othersocialmedia', with: '')
      fill_in('facebook', with: '')
      fill_in('photourl', with: '')
      click_button 'Save Changes'

      within 'div#bio-region-div' do
        expect(page).to have_content('Bio (edited) Some MORE bio info')
        expect(page).to have_content('Photo (URL) (none provided)')
        expect(page).to have_content('Web Site (none provided)')
        expect(page).to have_content('Twitter (none provided)')
        expect(page).to have_content('Facebook (none provided)')
        expect(page).to have_content('Other Social Media URL (none provided)')
      end
    end
  end
end
