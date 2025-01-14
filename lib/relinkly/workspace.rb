# frozen_string_literal: true

module Relinkly
  class Workspace < Element
    attr_accessor :id, :name, :avatarUrl, :links, :teammates,
                  :domains, :created_at, :updated_at
  end
end
