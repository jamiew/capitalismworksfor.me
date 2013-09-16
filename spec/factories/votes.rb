FactoryGirl.define do
  factory :vote do
    value "true"
    referrer "http://cnn.com"
    ip_address "8.8.8.8"
    user_agent "Mozilla something-or-other"
  end
end
