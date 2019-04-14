require 'rails_helper'

RSpec.describe Reading, type: :model do
  describe "#update_thermostat_stats" do

    let(:thermostat_stats) { 
      { total_readings: 2,     temperature_max: 30,
        temperature_min: 10,   temperature_avg: 20,
        humidity_max: 100,     humidity_min: 0,
        humidity_avg: 50,      battery_charge_max: 50,
        battery_charge_min: 1, battery_charge_avg: 25.5
      }.with_indifferent_access
    }

    it "verifies avg, min and max of temperature with +ve number" do
      Reading.update_thermostat_stats(thermostat_stats, "temperature", 70)
      expect(thermostat_stats[:temperature_max]).to eq(70)
      expect(thermostat_stats[:temperature_min]).to eq(10)
      expect(thermostat_stats[:temperature_avg]).to eq(110.to_d / 3)
    end

    it "verifies avg, min and max of humidity with +ve number" do
      Reading.update_thermostat_stats(thermostat_stats, "humidity", 11)
      expect(thermostat_stats[:humidity_max]).to eq(100)
      expect(thermostat_stats[:humidity_min]).to eq(0)
      expect(thermostat_stats[:humidity_avg]).to eq(111.to_d / 3)
    end

    it "verifies avg, min and max of battery_charge with +ve number" do
      Reading.update_thermostat_stats(thermostat_stats, "battery_charge", 0)
      expect(thermostat_stats[:battery_charge_max]).to eq(50)
      expect(thermostat_stats[:battery_charge_min]).to eq(0)
      expect(thermostat_stats[:battery_charge_avg]).to eq(51.to_d / 3)
    end

    it "verifies avg, min and max of temperature with -ve number" do
      Reading.update_thermostat_stats(thermostat_stats, "temperature", -70)
      expect(thermostat_stats[:temperature_max]).to eq(30)
      expect(thermostat_stats[:temperature_min]).to eq(-70)
      expect(thermostat_stats[:temperature_avg]).to eq(-30.to_d / 3)
    end

    it "verifies avg, min and max of humidity with -ve number" do
      Reading.update_thermostat_stats(thermostat_stats, "humidity", -11)
      expect(thermostat_stats[:humidity_max]).to eq(100)
      expect(thermostat_stats[:humidity_min]).to eq(-11)
      expect(thermostat_stats[:humidity_avg]).to eq(89.to_d / 3)
    end

    it "verifies avg, min and max of battery_charge with -ve number" do
      Reading.update_thermostat_stats(thermostat_stats, "battery_charge", -1)
      expect(thermostat_stats[:battery_charge_max]).to eq(50)
      expect(thermostat_stats[:battery_charge_min]).to eq(-1)
      expect(thermostat_stats[:battery_charge_avg]).to eq(50.to_d / 3)
    end
  end
end