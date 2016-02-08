FactoryGirl.define do
  factory :mail_config, class: MailConfig do
    info 'info@config.com'
    reply_to 'reply_to@config.com'
    cc 'cc@config.com'
    test_email 'test@config.com'
  end
end
