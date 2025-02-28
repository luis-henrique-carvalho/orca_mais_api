# frozen_string_literal: true

module Devise
  class CustomFailureApp < Devise::FailureApp
    def http_auth_body
      if request.format == :json
        json_error_response
      else
        super
      end
    end

    def json_error_response
      self.response_body = ::ErrorSerializer.render(
        {
          request_id: request.uuid,
          status: :unauthorized,
          errors: { base: [i18n_message] }
        }
      )
    end
  end
end
