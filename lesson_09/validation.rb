# frozen_string_literal: true

module Validation
  def self.included(klass)
    klass.extend ClassMethods
    klass.send :include, InstanceMethods

    klass.validations = []
  end

  module ClassMethods
    attr_accessor :validations

    def validate(attr, type, arg = nil)
      @validations << { attr: attr, type: type, arg: arg }
    end
  end

  module InstanceMethods
    ERROR_VALIDATION = 'Unsupported validation type!'
    ERROR_PRESENCE = 'Value must be present!'
    ERROR_FORMAT = 'Value does not match format!'
    ERROR_TYPE = 'Value has an unsupported type!'

    def valid?
      validate!

      true
    rescue ArgumentError
      false
    end

    private

    def validate!
      self.class.validations.each do |validation|
        var_attr = "@#{validation[:attr]}".to_sym

        value = instance_variable_get(var_attr)

        case validation[:type]
        when :presence then validate_presence!(value)
        when :format then validate_format!(value, validation[:arg])
        when :type then validate_type!(value, validation[:arg])
        else raise ArgumentError, ERROR_VALIDATION
        end
      end
    end

    def validate_presence!(value)
      raise ArgumentError, ERROR_PRESENCE if value.nil? || value == ''
    end

    def validate_format!(value, format)
      raise ArgumentError, ERROR_FORMAT if value !~ format
    end

    def validate_type!(value, type)
      raise ArgumentError, ERROR_TYPE unless value.is_a?(type)
    end
  end
end
