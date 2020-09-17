module Api::V1
  class RegistrationsController < Devise::RegistrationsController
    #before_action :ensure_params_exist, only: :create
    skip_before_action :verify_authenticity_token, :only => :create

    def create
      user = User.new user_params
      if user.save
        response_code = 'devise.registrations.signed_up'
        render json: {
          api_version: "api_v1",
          response_message: I18n.t(response_code),
          is_success: true,
          user: user
        }, status: 200
      else
        render json: {
          api_version: "api_v1",
          response_message: "Authentication Error",
          error_message: "Sign Up Failed",
          is_success: false,
          data: {}
        }, status: 400
      end
    end
    
    private

    def user_params
      params.permit(:username, :name, :email, :password, :password_confirmation)
    end
  
    def ensure_params_exist
      return if params[:user].present?
      render json: {
        api_version: "api_v1",
        response_message: "Authentication Error",
        error_message: "Missing Params",
        is_success: false,
        data: {}
      }, status: :bad_request
    end

  end
end
