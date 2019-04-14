require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe ReadingsController, type: :controller do
  let(:thermostat) { Thermostat.create(household_token: "81ed1639d2a7cad24be17a5e0724bc39", address: "64 West Beech Rd. New York, NY 10027.") }
  let(:set_headers) { request.headers["HTTP_HOUSEHOLD_TOKEN"] = thermostat.household_token}
  let(:reading_create_params) { { params: { reading: { thermostat_id: 1, temperature: 30, humidity: 22, battery_charge: 40 }, }, format: :json } }
  
  before do
    set_headers
    Rails.cache.clear
  end

  describe "POST #create" do
    it "creates a reading for a valid thermostat" do
      post :create, reading_create_params
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response["number"].to_s).to eq(1.to_s)
      expect(json_response["temperature"]).to eq(30.to_s)
      expect(json_response["humidity"]).to eq(22.to_s)
      expect(json_response["battery_charge"]).to eq(40.to_s)
      expect(json_response["thermostat_id"]).to eq(1.to_s)
    end

    it "creates a reading for a invalid thermostat" do
      thermostat_invalid_create_params = reading_create_params
      thermostat_invalid_create_params[:params][:reading][:thermostat_id] = -1
      post :create, thermostat_invalid_create_params
      expect(response).to have_http_status(404)
    end

    it "creates a reading without params" do
      post :create
      expect(response).to have_http_status(422)
    end
  end


  describe "GET #show" do
    it "fetches a created reading in db" do
      reading = Reading.create(reading_create_params[:params][:reading].merge(number: 15))
      get :show, params: { id: reading.number }
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response["number"].to_s).to eq(reading.number.to_s)
      expect(json_response["temperature"]).to eq(reading.temperature)
      expect(json_response["humidity"]).to eq(reading.humidity)
      expect(json_response["battery_charge"]).to eq(reading.battery_charge)
      expect(json_response["thermostat_id"]).to eq(reading.thermostat_id)
    end

    it "fetches a reading not created in db" do
      Sidekiq::Testing.disable! do
        post :create, reading_create_params
        expect(response).to have_http_status(:success)
        reading = reading_create_params[:params][:reading]
        json_create_response = JSON.parse(response.body)
        #Not created in DB
        expect(Reading.find_by(number: json_create_response["number"])).to be nil

        get :show, params: { id: json_create_response["number"] }
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response["temperature"]).to eq(reading[:temperature].to_s)
        expect(json_response["humidity"]).to eq(reading[:humidity].to_s)
        expect(json_response["battery_charge"]).to eq(reading[:battery_charge].to_s)
        expect(json_response["thermostat_id"]).to eq(reading[:thermostat_id].to_s)
      end
    end
  end
end

