# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :vote do
    value "1"
    referrer "http://cnn.com"
    ip_address "8.8.8.8"
    user_agent "Mozilla something-or-other"
  end
end
