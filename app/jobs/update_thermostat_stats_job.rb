class UpdateThermostatStatsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    options  = args.extract_options!
    thermostat_stats = Rails.cache.fetch("stats-#{options['thermostat_id']}")
    if thermostat_stats.present?
      Reading.update_thermostat_stats(thermostat_stats, "temperature", options[:temperature])
      Reading.update_thermostat_stats(thermostat_stats, "humidity", options[:humidity])
      Reading.update_thermostat_stats(thermostat_stats, "battery_charge", options[:battery_charge])
      thermostat_stats[:total_readings] += 1  
    else
       thermostat_stats = ActiveSupport::HashWithIndifferentAccess.new({
        total_readings:      1,
        temperature_max:    options[:temperature].to_d, 
        temperature_min:    options[:temperature].to_d,
        temperature_avg:    options[:temperature].to_d, 
        humidity_max:       options[:humidity].to_d,
        humidity_min:       options[:humidity].to_d,
        humidity_avg:       options[:humidity].to_d,
        battery_charge_max: options[:battery_charge].to_d,
        battery_charge_min: options[:battery_charge].to_d,
        battery_charge_avg: options[:battery_charge].to_d
      })
    end

    Rails.cache.write("stats-#{options['thermostat_id']}", thermostat_stats)
  end
end
