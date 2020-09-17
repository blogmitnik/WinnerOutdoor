module Api
  module V1
    class AccountUpdateController < Doorkeeper::TokensController
      before_action :doorkeeper_authorize!

      def update
      	raise ArgumentError.new("Can't update user information for unconfirmed user account") if current_user.confirmation_token

        case
	    when current_user&.inactive_message == :unconfirmed
          response_code = 'devise.failure.unconfirmed'
          render json: {
            api_version: "api_v1",
            response_code: response_code,
            response_message: I18n.t(response_code)
          }, status: 403
        else
          current_user.update!(user_params)

          response_code = 'devise.registrations.updated'
          render json: {
            api_version: "api_v1",
            response_code: response_code,
            response_message: I18n.t(response_code),
            is_success: true,
          }, status: 200
        end
      rescue ArgumentError => e
	    render json: {errors: {api_version: "api_v1", response_message: e.message} }, status: 422
	  rescue => e
	    render json: {errors: {api_version: "api_v1", response_message: e.message} }, status: 500
      end


      private

      def doorkeeper_unauthorized_render_options(error: nil)
        { json: { api_version: "api_v1", response_message: "Authentication Failed", error_message: I18n.t('doorkeeper.errors.messages.invalid_token.expired', authentication_keys: User.authentication_keys.join('/')), status: 401 } }
      end

      def user_params
        params.permit(:username, :name, :email)
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