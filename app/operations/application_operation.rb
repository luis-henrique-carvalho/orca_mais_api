# frozen_string_literal: true

# rubocop:disable Lint/UnusedMethodArgument
class ApplicationOperation
  attr_accessor :failed_step

  Response = Struct.new(:success?, :payload, :error, :status, :operation_class) do
    def failure?
      !success?
    end
  end

  class ForbiddenOperationException < StandardError; end
  class OperationInterruptionException < StandardError; end

  class OperationError < StandardError
    def initialize(message_key, klass)
      super("operation_exception.#{klass.underscore.gsub('/', '.')}.#{message_key}")
    end
  end

  def initialize(params)
    @params = params
  end

  def self.call(params:, options: {})
    service = new(params)
  rescue ActiveRecord::RecordNotFound => e
    service.failure(e, :not_found)
  rescue ForbiddenOperationException => e
    service.failure(e, :forbidden)
  rescue StandardError => e
    service.failure(e)
  end

  def self.call!(params:, options: {})
    service = new(params)
  rescue OperationInterruptionException => e
    service.failure(e)
  end

  def success(payload = nil)
    Response.new(true, payload)
  end

  def failure(exception, status = :unprocessable_entity, _options = {})
    Response.new(false, nil, exception, status, self.class)
  end

  def interrupt
    raise OperationInterruptionException
  end

  def raise_failure(message_key)
    raise OperationError.new(message_key, self.class.name)
  end

  protected

  # Overriding the method missing to create a new variable in a
  # operation when call set_<variable_name>(value)
  def method_missing(method_name, *args, &)
    if method_name.starts_with?('set_')
      new_method_name = method_name.to_s.gsub('set_', '')
      new_instace_variable_name = "@#{new_method_name}"
      return_value = args.first

      instance_variable_set(new_instace_variable_name, return_value)
    else
      super
    end
  end

  def respond_to_missing?(name, _include_private)
    name.starts_with?('set_')

    super
  end
end

# rubocop:enable Lint/UnusedMethodArgument
