class ApplicationController < ActionController::API
  before_action :authenticate_household_token

  def validate_thermostat
    head 403 and return unless @thermostat
  end

  def render_error(status, errors)
    render json: { errors: errors }, status: status
  end

  def authenticate_household_token
    household_token = request.headers["HTTP_HOUSEHOLD_TOKEN"]
    if household_token.present?
      @thermostat = Thermostat.find_by(household_token: household_token)
    end
    validate_thermostat
  end
end
