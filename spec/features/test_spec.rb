require 'rails_helper'

feature 'test' do
  scenario 'basic access' do
    visit '/'
    expect(page).to have_content('MyConvention')
  end
end
