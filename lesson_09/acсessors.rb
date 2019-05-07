# frozen_string_literal: true

module Acсessors
  def attr_accessor_with_history(*attrs)
    attrs.each do |attr|
      history_attr = "#{attr}_history"

      var_attr = "@#{attr}".to_sym
      var_attr_history = "@#{history_attr}".to_sym

      define_method(attr) { instance_variable_get(var_attr) }
      define_method(history_attr) { instance_variable_get(var_attr_history) }

      define_method("#{attr}=".to_sym) do |value|
        history = instance_variable_get(var_attr_history) || []
        history << value

        instance_variable_set(var_attr_history, history)
        instance_variable_set(var_attr, value)
      end
    end
  end
end
