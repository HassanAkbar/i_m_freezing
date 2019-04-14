class Reading < ApplicationRecord
  belongs_to :thermostat, touch: true

  def self.update_thermostat_stats(thermostat_stats, attribute_name, current_value)
    current_value  = current_value.to_d
    total_readings = thermostat_stats[:total_readings]
    if thermostat_stats["#{attribute_name}_max"] < current_value
      thermostat_stats["#{attribute_name}_max"] = current_value
    end

    if thermostat_stats["#{attribute_name}_min"] > current_value
      thermostat_stats["#{attribute_name}_min"] = current_value
    end

    thermostat_stats["#{attribute_name}_avg"] = ((total_readings * thermostat_stats["#{attribute_name}_avg"]) + current_value)
    thermostat_stats["#{attribute_name}_avg"] = thermostat_stats["#{attribute_name}_avg"] / (total_readings + 1)
    thermostat_stats
  end

  def self.update_thermostat_stats_in_cache(attributes)
    UpdateThermostatStatsJob.perform_later(attributes)
  end

  def self.create_reading_in_db(attributes)
    CreateReadingsInDbJob.perform_later(attributes)
  end

  def self.perform_background_tasks(updated_payload)
    updated_payload.each { |key, value| value.strip! if value === String }
    create_reading_in_db(updated_payload)
    update_thermostat_stats_in_cache(updated_payload)
  end
end
