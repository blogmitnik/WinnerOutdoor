module OmniAuth
  module Strategies
    class Webgoal < OmniAuth::Strategies::OAuth2
      option :name, "webgoal"

      option :client_options, {
        site: ENV['SITE_URL'],
        authorize_url: ENV['AUTHORIZE_URL']
      }

      uid { raw_info["id"] }

      info do
        {
          email: raw_info["email"],
          name: raw_info["name"]
        }
      end

      extra do
        {
          "raw_info": raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get("/api/v1/me").parsed
      end
    end
  end
end