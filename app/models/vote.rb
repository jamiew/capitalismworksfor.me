class Vote < ActiveRecord::Base
  validates_presence_of :value
  validates_presence_of :ip_address
  # validates_format_of :ip_address, :with => /^$/ # should be 4 octets

  # How long until you can vote again
  def self.cooldown_period
    1.hour
  end
end
