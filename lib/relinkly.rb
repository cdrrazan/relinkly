# frozen_string_literal: true

require 'relinkly/version'
require 'relinkly/configuration'
require 'relinkly/api'
require 'relinkly/element'
require 'relinkly/domain'
require 'relinkly/creator'
require 'relinkly/integration'
require 'relinkly/link'
require 'relinkly/workspace'
require 'relinkly/tag'

module Relinkly
  class << self
    attr_accessor :configuration
  end

  def self.api_key
    configuration.api_key
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end

class String
  def relinkly_underscore
    gsub(/::/, '/')
      .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
      .tr('-', '_')
      .downcase
  end

  def relinkly_camelize
    split('_').collect(&:capitalize).join
  end

  def relinkly_lower_camelize
    res = relinkly_camelize
    res[0].downcase + res[1..-1]
  end
end
