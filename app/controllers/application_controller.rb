# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_active_storage_url_options

  private

  def set_active_storage_url_options
    ActiveStorage::Current.url_options = { host: request.base_url }
  end
end
