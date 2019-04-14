class ReadingsController < ApplicationController

  # POST /readings
  def create
    begin
      if validate_reading_params(params[:reading])
        updated_payload = store_reading_sequence_num
        Reading.perform_background_tasks(updated_payload)
        render json: updated_payload, status: 200
      else
        if @thermostat.present?
          render_error(:unprocessable_entity, I18n.t(:unable_to_create_reading))
        else
          render_error(:not_found, I18n.t(:resource_not_found, resource: "Reading"))
        end
      end
    rescue => e
      logger.error e.message
      logger.error e.backtrace.join("\n")
      render_error(:internal_server_error, I18n.t(:unable_to_create_reading))
    end
  end

  # GET /readings/:id/
  def show
    begin
      @reading = Rails.cache.fetch("reading-#{params[:id]}")
      @reading = Reading.find_by(number: params[:id]) if @reading.blank?
      if @reading.present?
        render json: @reading.to_json, status: 200
      else
        render_error(:not_found, I18n.t(:resource_not_found, resource: "Reading"))
      end
    rescue => e
      logger.error e.message
      logger.error e.backtrace.join("\n")
      render_error(:internal_server_error, I18n.t(:unable_to_create_reading))
    end
  end

  private

  def store_reading_sequence_num  #can create a number problem for a multithreaded application
    latest_sequence_number = Rails.cache.fetch("latest_sequence_number").to_i + 1
    Rails.cache.write("latest_sequence_number", latest_sequence_number)
    updated_payload = reading_params.merge(number: latest_sequence_number)
    Rails.cache.write("reading-#{latest_sequence_number}", updated_payload)
    updated_payload
  end


  def reading_params
    params.require(:reading).permit(:thermostat_id, :temperature, :humidity, :battery_charge, :number)
  end

  def validate_reading_params(create_params)
    validated = create_params.present? && create_params[:thermostat_id].present? && create_params[:temperature].present? &&
      create_params[:humidity].present? && create_params[:battery_charge].present?
    validated && @thermostat = Thermostat.find_by(id: create_params[:thermostat_id]).present?
  end
end