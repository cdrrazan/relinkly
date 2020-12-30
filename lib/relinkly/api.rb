# frozen_string_literal: true

require 'httparty'

module Relinkly
  class RelinklyError < StandardError; end

  class RateLimitExceeded < RelinklyError; end

  class API
    API_VERSION = 'v1'
    BASE_URL = "https://api.rebrandly.com/#{API_VERSION}"

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
    def delete(id, options = {})
      Link.new(relinkly_request(:delete, "links/#{id}", options))
    end

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

    # GET /v1/account
    def account
      Creator.new(relinkly_request(:get, 'account'))
    end

    private

    def relinkly_request(method, url, options = {})
      url = "#{BASE_URL}/#{url}"
      # Convert all hash keys into camel case for Relinkly
      options = Hash[options.map { |k, v| [k.to_s.relinkly_lower_camelize.to_sym, v] }]

      http_attrs = { headers: headers }
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
