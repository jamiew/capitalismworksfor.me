class Vote < ActiveRecord::Base

  validates_presence_of :ip_address
  # validates_format_of :ip_address, :with => /^$/ # should be 4 octets
  validates_presence_of :value
  validates_inclusion_of :value, allow_blank: true, in: %w( true false ), message: "value %s is not included in the list"

  # Time until user can vote again
  def self.cooldown_period
    1.hour
  end
end
