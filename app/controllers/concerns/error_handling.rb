# frozen_string_literal: true

module ErrorHandling
  extend ActiveSupport::Concern

  def render_errors(errors, status:)
    render json: { errors: format_errors(errors), request_id: request.uuid }, status:
  end

  private

  def format_errors(errors)
    case errors
    when ActiveRecord::RecordInvalid
      errors.record.errors.messages
    when String
      format_string_errors(errors)
    else
      format_generic_errors(errors)
    end
  end

  def format_string_errors(error)
    error_key = "errors.messages.#{error.underscore}"

    message = I18n.t(error_key, default: error)

    { base: [message] }
  end

  def format_generic_errors(error)
    error_key = "errors.messages.#{error.class.name.underscore.gsub('/', '.')}"

    message = if I18n.exists?(error.message)
                I18n.t(error.message)
              elsif error.respond_to?(:model)
                I18n.t(error_key, default: error.message, model: error.model, id: error.id)
              else
                error.message
              end

    { base: [message] }
  end
end
