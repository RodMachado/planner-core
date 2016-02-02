require 'rails_helper'

feature 'User Login' do
  scenario 'basic access' do
    visit '/'
    expect(page).to have_content('MyConvention')
  end
end
