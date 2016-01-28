FactoryGirl.define do
  factory :default_site_config, class: SiteConfig do
    name 'MyConvention'
    start_date '01/02/2016'
    public_start_date '03/02/2016'
    number_of_days 10
    public_number_of_days 5
    time_zone 'Eastern Time (US & Canada)'
    print_time_format '24'
  end
end
