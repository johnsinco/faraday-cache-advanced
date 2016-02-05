module Faraday
  class CacheAdvanced < Faraday::Middleware

    attr_accessor :store

    register_middleware :post_cache => CacheAdvanced

    def initialize(app, cache = nil, opts = {})
      @app = app
      if(storename = opts.delete(:store))
        @store = lookup_store(storename)
      else
        @store = cache || yield
      end
    end

    def call(env)
      key = cache_key(env)
      response = store.read(key)

      if(response.nil? || env[:request_headers].delete(:must_revalidate))
        response = @app.call(env)
        store.write(key, response) if response.success?
      end

      env[:response] = response
      env.update response.env unless env[:response_headers]
      response.env[:method] = env[:method]
      response.env[:url] = env[:url]

      response
    end

    def cache_key(env)
      "#{env[:url]}/#{env[:body]}"
    end

    def lookup_store(name, opts)
      ActiveSupport::Cache.lookup_store(name.to_sym, opts)
    end

  end
end
