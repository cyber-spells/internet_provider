class ApplicationController < ActionController::Base
  require 'sendpulse/smtp_service'

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_defaults

  protect_from_forgery

  def access_denied(exception)
    redirect_to root_path, alert: exception.message
  end

  protected

  def set_defaults
    @smtp_service = SendPulse::SmtpService.new(ENV['SENDPULSE_CLIENT_ID'], ENV['SENDPULSE_CLIENT_SECRET'], 'https', nil)
  end

  def configure_permitted_parameters
    added_attrs = [:username, :phone, :full_name, :tariff_id, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: [:login, :password]
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
