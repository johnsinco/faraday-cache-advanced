# Faraday::Cache::Advanced

A simple mechanism to cache POST requests via a faraday middleware.

Cache Advanced is a tool for when you REALLY, REALLY need to cache POST HTTP requests via Faraday.  
In general you SHOULD NOT cache POST calls, as they are not supposed to be idempotent, but yeah 
that doesnt always hold in the real world.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'faraday-cache-advanced'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install faraday-cache-advanced

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/[my-github-username]/faraday-cache-advanced/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
