# frozen_string_literal: true

module Users
  class Show < ApplicationOperation
    def call(user)
      success user
    end
  end
end
