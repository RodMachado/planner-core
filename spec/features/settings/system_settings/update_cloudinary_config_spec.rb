require 'rails_helper'

feature 'Update cloudinary_config' do
  let!(:user) { FactoryGirl.create(:user, login: 'user') }
  let!(:admin_role) { FactoryGirl.create(:admin_role) }
  let!(:role_assignment) do
    FactoryGirl.create(
      :role_assignment,
      user: user,
      role: admin_role
    )
  end

  let!(:cloudinary_config) { FactoryGirl.create(:cloudinary_config) }

  before do
    login_as(user)
  end

  context 'main' do
    scenario 'update cloudinary_config', js: true do
      visit '/'
      click_link 'Settings'
      click_link 'System Settings'
      click_link 'Cloudinary Image Management'
      find('.model-edit-button').click

      fill_in('cloud_name', with: 'my_cloud_name')
      fill_in('api_key', with: '111111')
      fill_in('api_secret', with: '222222')
      check('enhance_image_tag')
      check('static_image_support')
      click_button 'Save Changes'

      expect(page).to have_content('Cloudinary API Key 111111')
      expect(page).to have_content('Cloudinary API Secret 222222')
      expect(page).to have_content('Cloudinary Cloud Name my_cloud_name')
      expect(page).to have_content('Cloudinary Enhance Image Tag Yes')
      expect(page).to have_content('Cloudinary Static Image Support Yes')
    end
  end
end
