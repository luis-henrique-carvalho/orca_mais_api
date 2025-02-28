# frozen_string_literal: true

class ErrorSerializer < ApplicationSerializer
  identifier :request_id

  fields :message, :errors
end
