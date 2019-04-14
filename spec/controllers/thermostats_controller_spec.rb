require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.inline!

RSpec.describe ThermostatsController, type: :controller do
  let(:thermostat) { Thermostat.create(household_token: "81ed1639d2a7cad24be17a5e0724bc39", address: "64 West Beech Rd. New York, NY 10027.") }
  let(:set_headers) { request.headers["HTTP_HOUSEHOLD_TOKEN"] = thermostat.household_token}
  
  before do
    set_headers
     Rails.cache.clear
  end

  describe "GET #stats" do
    it "gets stats for a invalid thermostat" do
      get :stats, params: { id: -1}
      expect(response).to have_http_status(404)
    end

    it "gets stats of a valid thermostat without any reading" do
      get :stats, params: { id: thermostat.id}
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response["total_readings"]).to eq(0)
      expect(json_response["temperature_max"]).to eq(0)
      expect(json_response["temperature_min"]).to eq(0)
      expect(json_response["temperature_avg"]).to eq(0)
      expect(json_response["humidity_max"]).to eq(0)
      expect(json_response["humidity_min"]).to eq(0)
      expect(json_response["humidity_avg"]).to eq(0)
      expect(json_response["battery_charge_max"]).to eq(0)
      expect(json_response["battery_charge_min"]).to eq(0)
      expect(json_response["battery_charge_avg"]).to eq(0)
    end

    it "gets stats of a thermostat with one reading" do
      reading_create_params = { params: { reading: { thermostat_id: 1, temperature: 30, humidity: 20, battery_charge: 10 }, }, format: :json }
      @controller = ReadingsController.new
      post :create, reading_create_params
      expect(response).to have_http_status(:success)
      @controller = ThermostatsController.new
      get :stats, params: { id: 1 }
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)

      expect(json_response["total_readings"]).to eq(1)
      expect(json_response["temperature_max"].to_d).to eq(30.to_d)
      expect(json_response["temperature_min"].to_d).to eq(30.to_d)
      expect(json_response["temperature_avg"].to_d).to eq(30.to_d)
      expect(json_response["humidity_max"].to_d).to eq(20.to_d)
      expect(json_response["humidity_min"].to_d).to eq(20.to_d)
      expect(json_response["humidity_avg"].to_d).to eq(20.to_d)
      expect(json_response["battery_charge_max"].to_d).to eq(10.to_d)
      expect(json_response["battery_charge_min"].to_d).to eq(10.to_d)
      expect(json_response["battery_charge_avg"].to_d).to eq(10.to_d)

    end

    it "gets stats of a thermostat with many readings" do
    @controller = ReadingsController.new
    reading_create_params = { params: { reading: { thermostat_id: 1, temperature: 30, humidity: 20, battery_charge: 10 }, }, format: :json }
    post :create, reading_create_params
    reading_create_params = { params: { reading: { thermostat_id: 1, temperature: 60, humidity: 40, battery_charge: 50 }, }, format: :json }
    post :create, reading_create_params
    reading_create_params = { params: { reading: { thermostat_id: 1, temperature: 90, humidity: 60, battery_charge: 60 }, }, format: :json }
    post :create, reading_create_params
    reading_create_params = { params: { reading: { thermostat_id: 1, temperature: 120, humidity: 80, battery_charge: 30 }, }, format: :json }
    post :create, reading_create_params
    reading_create_params = { params: { reading: { thermostat_id: 1, temperature: 150, humidity: 100, battery_charge: 5 }, }, format: :json }
    post :create, reading_create_params
    @controller = ThermostatsController.new
    get :stats, params: { id: 1 }
    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)

    expect(json_response["total_readings"]).to eq(5)
    expect(json_response["temperature_max"].to_d).to eq(150.to_d)
    expect(json_response["temperature_min"].to_d).to eq(30.to_d)
    expect(json_response["temperature_avg"].to_d).to eq(90.to_d)
    expect(json_response["humidity_max"].to_d).to eq(100.to_d)
    expect(json_response["humidity_min"].to_d).to eq(20.to_d)
    expect(json_response["humidity_avg"].to_d).to eq(60.to_d)
    expect(json_response["battery_charge_max"].to_d).to eq(60.to_d)
    expect(json_response["battery_charge_min"].to_d).to eq(5.to_d)
    expect(json_response["battery_charge_avg"].to_d).to eq(31.to_d)
    end
  end 
end