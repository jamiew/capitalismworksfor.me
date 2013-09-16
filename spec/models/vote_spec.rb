require 'spec_helper'

describe Vote do

  it "factory is valid" do
    FactoryGirl.build(:vote).should be_valid
  end

  it "is invalid without IP address" do
    FactoryGirl.build(:vote, ip_address: nil).should_not be_valid
  end

  it "is invalid without value" do
    FactoryGirl.build(:vote, value: nil).should_not be_valid
  end

  it "is invalid if value is not 'true' or 'false'" do
    FactoryGirl.build(:vote, value: 'true').should be_valid
    FactoryGirl.build(:vote, value: 'false').should be_valid
    FactoryGirl.build(:vote, value: 'anything').should_not be_valid
  end

end
