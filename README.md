# relinkly [![Gem Version](https://badge.fury.io/rb/relinkly.svg)](https://badge.fury.io/rb/relinkly)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'relinkly'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install relinkly

## Usage

If using Rails, put the following into your application.rb. If just Ruby,
run this before trying to use the API.

```ruby
Relinkly.configure do |config|
  config.api_key = 'YOUR_KEY_HERE'
end
```

### Instantiate an API object.

```ruby
api = Relinkly::API.new
```

### API Requests

#### Account, Workspaces & Domains

```ruby
api.account                         # GET /v1/account
api.workspaces                      # GET /v1/workspaces
api.domains                         # GET /v1/domains
api.domain(id)                      # GET /v1/domains/:id
api.domain_count(options)           # GET /v1/domains/count
```

#### Links
```ruby
api.links                           # GET /v1/links
api.link(id)                        # GET /v1/links/:id
api.link_count(options)             # GET /v1/links/count
api.new_link(options)               # GET /v1/links/new
api.shorten(destination, options)   # POST /v1/links
api.update_link(id, options)        # POST /v1/links/:id
api.delete_links(ids, options)      # DELETE /v1/links
api.delete_link(id, options)        # DELETE /v1/links/:id
api.tags_link(id, options)          # GET /v1/links/:id/tags
api.add_tag_link(id, options)       # POST /v1/links/:id/tags
api.delete_tag_link(id, options)    # DELETE /v1/links/:id/tags
api.scripts_link(id, options)       # GET /v1/links/:id/scripts
api.add_script_link(id, options)    # POST /v1/links/:id/scripts
api.delete_script_link(id, options) # DELETE /v1/links/:id/scripts
```

#### Tags
```ruby
api.tags                           # GET /v1/tags
api.tag(id)                        # GET /v1/tags/:id
api.tag_count(options)             # GET /v1/tags/count
api.new_tag(options)               # POST /v1/tags
api.update_tag(id, options)        # POST /v1/tags/:id
api.delete_tag(id, options)        # DELETE /v1/tags/:id
```

#### Scripts
```ruby
api.scripts                        # GET /v1/scripts
api.script(id)                     # GET /v1/scripts/:id
api.script_count(options)          # GET /v1/scripts/count
```


#### Creating your branded short link!

```ruby
your_domain = api.domains.first
branded_link = api.shorten('https://google.com', domain: your_domain.to_h, title: 'Google', description: 'Google Homepage')
```

#### Workspace workaround
Please see the applicable methods for options available when making requests. You need to pass the workspace_id in the options as follows in case you want to select other than the default workspace.

Here's how you can achieve that:

```ruby
your_domain = api.domains.first
your_workspace_id = api.workspaces.first.id
branded_link = api.shorten('https://google.com', domain: your_domain.to_h, title: 'Google', description: 'Google Homepage', workspace: your_workspace_id)
```

Please note that `your_domain` should already be included inside `your_workspace`.

You can find all the details about your workspace by going here. https://app.rebrandly.com/workspaces


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cdrrazan/relinkly.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
