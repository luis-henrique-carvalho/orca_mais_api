# frozen_string_literal: true

class ApplicationSerializer < Blueprinter::Base
  class_attribute :child_serializers

  def self.sti(type, serializer)
    self.child_serializers ||= {}
    self.child_serializers[type] = serializer
  end

  def self.render_sti(object, options = {})
    if object.is_a?(Enumerable)
      object.map { |item| render_single(item, options.dup) }
    else
      render_single(object, options)
    end
  end

  def self.render_single(object, options = {})
    serializer_class = child_serializers[object.type] || self
    serializer_class.render_as_hash(object, options)
  end
end
