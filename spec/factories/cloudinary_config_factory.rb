FactoryGirl.define do
  factory :cloudinary_config, class: CloudinaryConfig do
    cloud_name 'my_cloud'
    api_key '123456'
    api_secret '123456'
    enhance_image_tag false
    static_image_support false
  end
end
