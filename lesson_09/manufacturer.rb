# frozen_string_literal: true

module Railway
  module Manufacturer
    extend Accessors

    attr_accessor_with_history :manufacturer
  end
end
