FactoryGirl.define do
  factory :person, class: Person do
    prefix 'Mr'
    first_name 'Foo'
    last_name 'Bar'
    suffix 'Ph.D'
    company 'Grenadine'
    job_title 'Developer'
  end
end
