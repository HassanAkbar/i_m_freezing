class Thermostat < ApplicationRecord
  has_many :readings
  def self.cache_key(thermostats)
    {
      serializer: 'theromstats',
      stat_record: theromstats.maximum(:updated_at)
    }
  end
end
