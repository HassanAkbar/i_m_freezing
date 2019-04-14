class ThermostatsController < ApplicationController

 # GET /thermostats/:id/stats
  def stats
    if Thermostat.find_by(id: params[:id]).present?
      render json: fetch_stats, status: 200
    else
      render_error(:not_found, I18n.t(:resource_not_found, resource: "Thermostat"))
    end
    
  end

  private

  def fetch_stats
    Rails.cache.fetch("stats-#{params[:id]}") || {
      total_readings:     0, temperature_max:    0, 
      temperature_min:    0, temperature_avg:    0, 
      humidity_max:       0, humidity_min:       0,
      humidity_avg:       0, battery_charge_max: 0,
      battery_charge_min: 0, battery_charge_avg: 0
    }
  end

end