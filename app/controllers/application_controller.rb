require "securerandom"

class ApplicationController < ActionController::Base
  include UsersHelper

  protect_from_forgery with: :exception
  before_action :authenticate_user!
    before_action :configure_permitted_parameters, if: :devise_controller?

    class Forbidden < ActionController::ActionControllerError; end
  class IpAddressRejected < ActionController::ActionControllerError; end

  rescue_from Exception, with: :rescue500
  rescue_from Forbidden, with: :rescue403
  rescue_from IpAddressRejected, with: :rescue403
  rescue_from ActionController::RoutingError, with: :rescue404
  rescue_from ActiveRecord::RecordNotFound, with: :rescue404
  rescue_from Timeout::Error, with: :rescue524
    
  protected
    
    def configure_permitted_parameters
    	devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :name, :email, :password)}
    	devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:email, :password, :remember_me) }
        devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:username, :name, :email, :password, :password_confirmation, :current_password)}
        devise_parameter_sanitizer.permit(:accept_invitation) { |u| u.permit(:invitation_token, :username, :name, :password, :password_confirmation)}
  	end

    def rescue400(e)
      @exception = e
      error_info = {
        :error => "Bad request",
        :exception => "#{e.class.name} : #{e.message}",
      }
      error_info[:trace] = e.backtrace[0,10] if Rails.env.development?
      respond_to do |format|
        format.json{ render json: error_info.to_json, status: 400 }
        format.html{ render 'errors/bad_request', status: 400 }
      end
    end

    def rescue403(e)
      @exception = e
      error_info = {
        :error => "Unauthorized",
        :exception => "#{e.class.name} : #{e.message}",
      }
      error_info[:trace] = e.backtrace[0,10] if Rails.env.development?
      respond_to do |format|
        format.json{ render json: error_info.to_json, status: 403 }
        format.html{ render 'errors/forbidden', status: 403 }
      end
    end

    def rescue404(e)
      @exception = e
      error_info = {
        :error => "Resource not found",
        :exception => "#{e.class.name} : #{e.message}",
      }
      error_info[:trace] = e.backtrace[0,10] if Rails.env.development?
      respond_to do |format|
        format.json{ render json: error_info.to_json, status: 404 }
        format.html{ render 'errors/not_found', status: 404 }
      end
    end

    def rescue500(e)
      @exception = e
      error_info = {
        :error => "Internal server error",
        :exception => "#{e.class.name} : #{e.message}",
      }
      error_info[:trace] = e.backtrace[0,10] if Rails.env.development?
      respond_to do |format|
        format.json{ render json: error_info.to_json, status: 500 }
        format.html{ render 'errors/internal_server_error', status: 500 }
      end
    end

    def rescue524(e)
      @exception = e
      error_info = {
        :error => "A timeout occurred",
        :exception => "#{e.class.name} : #{e.message}",
      }
      error_info[:trace] = e.backtrace[0,10] if Rails.env.development?
      respond_to do |format|
        format.json{ render json: error_info.to_json, status: 524 }
        format.html{ render 'errors/timeout_occurred', status: 524 }
      end
    end
end
