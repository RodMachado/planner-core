FactoryGirl.define do
  factory :postal_address, class: PostalAddress do
    line1 'Address 1'
    line2 'Address 2'
    line3 'Address 3'
    city 'Montreal'
    state 'Quebec'
    postcode 'a1b 2c3'
    country 'Country'
  end
end
