FactoryGirl.define do
  factory :user, class: User do
    login 'login'
    email 'foo@bar.com'
    password 'password'
  end
end
