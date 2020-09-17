module Api
  module V1
    class TokensController < Doorkeeper::TokensController
      before_action :doorkeeper_authorize!, only: [:destroy]

      def create
        user = User.find_for_database_authentication(email: params[:email])

        case
        when user.nil? || !user.valid_password?(params[:password])
          response_code = 'devise.failure.invalid'
          render json: {
            api_version: "api_v1",
            response_message: "Authentication Error",
            error_message: I18n.t(response_code)
          }, status: :not_found
        when user&.inactive_message == :unconfirmed
          response_code = 'devise.failure.unconfirmed'
          render json: {
            api_version: "api_v1",
            response_message: "Authentication Error",
            error_message: I18n.t(response_code)
          }, status: 400
        else
          sign_in "user", user
          #sign_in(user, store: false) # store false would not store user session
          response_code = 'devise.sessions.signed_in'
          render json: {
            api_version: "api_v1",
            response_message: I18n.t(response_code),
            is_success: true,
            data: {user: user}
          }, status: 200
        end
      end

      def destroy
        params[:token] = access_token
        revoke_token if authorized?
        current_user = @current_user || User.find_by(id: doorkeeper_token.resource_owner_id)
        sign_out current_user if current_user

        response_code = 'devise.sessions.signed_out'
        render json: {
          api_version: "api_v1",
          response_code: response_code,
          response_message: I18n.t(response_code),
          is_success: true,
        }, status: 200
      end

      private

      def doorkeeper_unauthorized_render_options(error: nil)
        { json: { api_version: "api_v1", message: I18n.t('doorkeeper.errors.messages.invalid_token.expired', authentication_keys: User.authentication_keys.join('/')), status: 401 } }
      end

      def access_token
        pattern = /^Bearer /
        header = request.headers['Authorization']
        if header && header.match(pattern)
          header.gsub(pattern, '')
        else
          params[:access_token]
        end
      end

      # def current_user
      #   @current_user ||= User.find_by(id: doorkeeper_token.resource_owner_id)
      # end
    end
  end
end