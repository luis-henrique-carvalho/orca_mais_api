# frozen_string_literal: true

RSpec::Matchers.define :have_specific_keys do |*expected_keys|
  match do |actual|
    actual.is_a?(Hash) && (actual.keys.map(&:to_s).sort == expected_keys.flatten.map(&:to_s).sort)
  end

  failure_message do |actual|
    "expected that the hash would have only the keys #{expected_keys.flatten.sort}, but found #{actual.keys.sort}"
  end
end
