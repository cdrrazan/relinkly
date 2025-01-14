# frozen_string_literal: true

require 'httparty'
require 'json'

module Relinkly
  class RelinklyError < StandardError; end

  class RateLimitExceeded < RelinklyError; end

  class API
    API_VERSION = 'v1'
    BASE_URL = "https://api.rebrandly.com/#{API_VERSION}"

    ########################################
    # ACCOUNT / WORKSPACES
    ########################################
    #
    # ACCOUNT ENDPOINTS
    #
    ########################################

    # GET /v1/account
    def account
      Creator.new(relinkly_request(:get, 'account'))
    end

    # WORKSPACES ENDPOINTS
    #
    ########################################

    # GET /v1/account/workspaces
    def workspaces(options = {})
      all_workspaces = relinkly_request(:get, 'workspaces', options)
      all_workspaces.map { |workspace| Workspace.new(workspace) }
    end

    ########################################
    # REBRANDLY OPS
    ########################################
    #
    # DOMAINS ENDPOINTS
    #
    ########################################

    # GET /v1/domains
    def domains(options = {})
      all_domains = relinkly_request(:get, 'domains', options)
      all_domains.map { |domain| Domain.new(domain) }
    end

    # GET /v1/domains/:id
    def domain(id)
      Domain.new(relinkly_request(:get, "domains/#{id}"))
    end

    # GET /v1/domains/count
    def domain_count(_options = {})
      relinkly_request(:get, 'domains/count')['count']
    end

    # TAGS ENDPOINTS
    #
    ########################################

    # GET /v1/tags
    def tags(options = {})
      all_tags = relinkly_request(:get, 'tags', options)
      all_tags.map { |tag| Tag.new(tag) }
    end

    # GET /v1/tags/:id
    def tag(id)
      Tag.new(relinkly_request(:get, "tags/#{id}"))
    end

    # GET /v1/tags/count
    def tag_count(_options = {})
      relinkly_request(:get, 'tags/count')['count']
    end

    # POST /v1/tags
    def new_tag(destination, options = {})
      options[:destination] = destination
      Tag.new(relinkly_request(:post, 'tags', options))
    end

    # POST /v1/tags/:id
    def update_tag(id, options = {})
      Tag.new(relinkly_request(:post, "tags/#{id}", options))
    end

    # DELETE /v1/tags/:id
    def delete_tag(id, options = {})
      Tag.new(relinkly_request(:delete, "tags/#{id}", options))
    end

    # LINKS ENDPOINTS
    #
    ########################################

    # GET /v1/links
    def links(options = {})
      all_links = relinkly_request(:get, 'links', options)
      all_links.map { |link| Link.new(link) }
    end

    # GET /v1/links/:id
    def link(id)
      Link.new(relinkly_request(:get, "links/#{id}"))
    end

    # GET /v1/links/count
    def link_count(_options = {})
      relinkly_request(:get, 'links/count')['count']
    end

    # POST /v1/links
    def shorten(destination, options = {})
      options[:destination] = destination
      Link.new(relinkly_request(:post, 'links', options))
    end

    # POST /v1/links/:id
    def update_link(id, options = {})
      Link.new(relinkly_request(:post, "links/#{id}", options))
    end

    # DELETE /v1/links/:id
    def delete_link(id, options = {})
      Link.new(relinkly_request(:delete, "links/#{id}", options))
    end

    # DELETE /v1/links
    def delete_links(options = {})
      Link.new(relinkly_request(:delete, 'links', options))
    end

    # GET /v1/links/:id/tags
    def tags_link(id, options = {})
      Link.new(relinkly_request(:get, "/links/#{id}/tags", options))
    end

    # POST /v1/links/:id/tags/:tag
    def add_tags_link(id, tag, options = {})
      Link.new(relinkly_request(:post, "/links/#{id}/tags/#{tag}", options))
    end

    # DELETE /v1/links/:id/tags/:tag
    def delete_tags_link(id, tag, options = {})
      Link.new(relinkly_request(:delete, "/links/#{id}/tags/#{tag}", options))
    end

    # GET /v1/links/:id/scripts
    def scripts_link(id, options = {})
      Link.new(relinkly_request(:get, "/links/#{id}/scripts", options))
    end

    # POST /v1/links/:id/scripts/:script
    def add_scripts_link(id, script, options = {})
      Link.new(relinkly_request(:post, "/links/#{id}/scripts/#{script}", options))
    end

    # DELETE /v1/links/:id/scripts/:script
    def delete_scripts_link(id, script, options = {})
      Link.new(relinkly_request(:delete, "/links/#{id}/scripts/#{script}", options))
    end

    # SCRIPTS ENDPOINTS
    #
    ########################################

    # GET /v1/scripts
    def scripts(options = {})
      all_scripts = relinkly_request(:get, 'scripts', options)
      all_scripts.map { |script| Script.new(script) }
    end

    # GET /v1/scripts/:id
    def script(id)
      Script.new(relinkly_request(:get, "scripts/#{id}"))
    end

    # GET /v1/scripts/count
    def script_count(_options = {})
      relinkly_request(:get, 'scripts/count')['count']
    end

    private

    def relinkly_request(method, url, options = {})
      url = "#{BASE_URL}/#{url}"
      # Convert all hash keys into camel case for Relinkly
      options = Hash[options.map { |k, v| [k.to_s.relinkly_lower_camelize.to_sym, v] }]
      workspace_id = options[:workspace]

      # Passes the workspace_id into header if the operation requires workspace_id to be included.
      header_with_workspace = workspace_id.nil? ? headers : headers.merge!('workspace' => workspace_id)
      http_attrs = { headers: header_with_workspace }
      case method
      when :get
        http_attrs.merge!(query: options)
      when :post
        http_attrs.merge!(body: options.to_json)
      end

      res = HTTParty.send(method, url, http_attrs)
      if res.code == 200
        JSON.parse(res.body)
      else
        relinkly_error = res.parsed_response
        if relinkly_error['domain'] == 'usageLimits' && relinkly_error['reason'] == 'rateLimitExceeded'
          raise RateLimitExceeded
        else
          raise RelinklyError, relinkly_error['message']
        end
      end
    end

    def headers
      {
        'Content-type' => 'application/json',
        'apikey' => Relinkly.api_key
      }
    end
  end
end
