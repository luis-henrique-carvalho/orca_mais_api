# frozen_string_literal: true

module ExpectResponseHelper
  def expect_error(attribute, message_key, options: {}, message_key_type: 'errors.messages')
    response_body = JSON.parse(response.body).with_indifferent_access
    translated_message = I18n.t("#{message_key_type}.#{message_key}", **options)

    expect(response_body['errors']).to include(attribute)
    expect(response_body['errors'][attribute]).to include(translated_message)
  end

  def expect_multiple_errors(expected_errors, options = {})
    response_body = JSON.parse(response.body).with_indifferent_access

    expected_errors.each do |attribute, message_keys|
      expect(response_body['errors']).to include(attribute)

      message_keys.each do |message_key|
        translated_message = I18n.t("errors.messages.#{message_key}", **options)
        expect(response_body['errors'][attribute]).to include(translated_message)
      end
    end
  end
end
