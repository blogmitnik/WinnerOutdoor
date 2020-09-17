module Api
  module V1
    class ResetPasswordController < Doorkeeper::TokensController
      before_action :doorkeeper_authorize!
      before_action :reset_password_params, only: :create

	  def create
		raise ArgumentError.new("Password doesn't match") unless reset_password_params[:new_password] == reset_password_params[:confirm_new_password]
		raise ArgumentError.new("Can't reset password for unconfirmed user account") if current_user.confirmation_token

		case
		when current_user&.inactive_message == :unconfirmed
          response_code = 'devise.failure.unconfirmed'
          render json: {
            api_version: "api_v1",
            response_code: response_code,
            response_message: I18n.t(response_code)
          }, status: 403
        when current_user.nil? || !current_user.valid_password?(params[:current_password])
          response_code = 'devise.failure.current_password_error'
          render json: {
            api_version: "api_v1",
            response_message: "Incorrect Current Password",
            error_message: I18n.t(response_code)
          }, status: 403
        else
          current_user.update!(password: reset_password_params[:new_password])
          #doorkeeper_token.destroy! # Current access_token will be destroy

          response_code = 'devise.passwords.updated_not_active'
          render json: {
          	api_version: "api_v1",
            response_message: I18n.t(response_code),
            is_success: true
		  }, status: 200
        end
	  rescue ArgumentError => e
	    render json: {api_version: "api_v1", response_message: e.message, error_message: e.message}, status: 422
	  rescue => e
	    render json: {api_version: "api_v1", response_message: e.message, error_message: e.message}, status: 500
      end


      private

      def doorkeeper_unauthorized_render_options(error: nil)
        { json: { api_version: "api_v1", response_message: "Authentication Failed", error_message: I18n.t('doorkeeper.errors.messages.invalid_token.expired', authentication_keys: User.authentication_keys.join('/')), status: 401 } }
      end

      def reset_password_params
      	params.permit(:current_password, :new_password, :confirm_new_password)
      end

      def current_user
      	if doorkeeper_token
          User.find(doorkeeper_token.resource_owner_id)
        else
          warden.authenticate(scope: :user, store: false)
        end
      end
    end
  end
end