FactoryGirl.define do

  sequence :ip_address do
    4.times.map { (rand*255).ceil }.join('.')
  end

  factory :vote do
    value "true" # set a default
    referrer "http://cnn.com"
    ip_address { FactoryGirl.generate(:ip_address) }
    user_agent "Mozilla something-or-other"
  end

  factory :true_vote, parent: :vote do
    value "true"
  end

  factory :false_vote, parent: :vote do
    value "false"
  end


end
