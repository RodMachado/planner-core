FactoryGirl.define do
  factory :edited_bio, class: EditedBio do
    bio 'Some bio info'
    website 'website.com'
    twitterinfo 'twitter.com/me'
    othersocialmedia 'other.com/me'
    facebook 'facebook.com/me'
    photourl 'photo.com/me.jpg'
  end
end
