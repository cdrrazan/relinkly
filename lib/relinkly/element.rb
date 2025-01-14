# frozen_string_literal: true

module Relinkly
  # General class to map Relinkly objects to Ruby objects
  class Element
    def initialize(attrs = {})
      # Only set the attributes if the method exists, this way we can ignore deprecated attributes
      attrs.each { |k, v| send("#{k.relinkly_underscore}=", v) if respond_to?("#{k.relinkly_underscore}=") }
    end

    def to_h
      Hash[
        *instance_variables.map do |variable|
          name = variable[1..-1].to_sym # Drop the @ sign at the front
          [name.to_sym, instance_variable_get(variable)]
        end.flatten
      ]
    end
  end
end
