# frozen_string_literal: true

module Relinkly
  class Domain < Element
    attr_accessor :id, :ref, :full_name, :top_level_domain, :level,
                  :created_at, :updated_at, :custom_homepage, :owner_id, :type,
                  :subdomains, :managed, :status, :https, :active
  end
end
