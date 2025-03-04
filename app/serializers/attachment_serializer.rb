# frozen_string_literal: true

class AttachmentSerializer < ApplicationSerializer
  identifier :id

  field :content_type do |object, _params|
    object.blob&.content_type
  end

  # TODO: This field should be removed once we update the frontend to work without it
  field :attachment_id do |object, _params|
    object.id
  end

  field :url do |object, _params|
    if object.blob&.service&.public?
      "https://#{ENV.fetch('ASSETS_CDN_DOMAIN', nil)}/#{object.blob.key}"
    else
      object.blob&.url
    end
  end
end
