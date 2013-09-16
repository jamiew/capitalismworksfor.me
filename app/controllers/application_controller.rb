class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def request_ip_address
    ip_address = request.headers['HTTP_X_FORWARDED_FOR'].to_s.split(',').last || request.ip
    ip_address.present? && ip_address.strip || nil
  end
  helper_method :request_ip_address
end
