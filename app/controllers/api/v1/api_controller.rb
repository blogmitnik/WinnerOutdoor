module Api::V1
  class ApiController < ::ApplicationController
  	include SerializableResource
    include Response

  	before_action :doorkeeper_authorize! # Equivalent of authenticate_user!
  	skip_before_action :authenticate_user!

    def current_resource_owner
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end

    def doorkeeper_unauthorized_render_options(error: nil)
      { json: { api_version: "api_v1", message: I18n.t('doorkeeper.errors.messages.invalid_token.expired', authentication_keys: User.authentication_keys.join('/')), status: 401 } }
    end
  end
end