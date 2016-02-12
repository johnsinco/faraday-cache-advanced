require 'faraday'
require 'faraday/cache-advanced/cache-advanced'

describe Faraday::CacheAdvanced do

  before do
    @cache = TestCache.new
    request_count = 0
    response = lambda { |env|
      [200, {'Content-Type' => 'text/plain'}, "request:#{request_count+=1}"]
    }
    broken = lambda { |env|
      [500, {'Content-Type' => 'text/plain'}, "request:#{request_count+=1}"]
    }
    @conn = Faraday.new do |b|
      b.use CachingLint
      b.use Faraday::CacheAdvanced, @cache, options
      b.adapter :test do |stub|
        stub.get('/', &response)
        stub.get('/?foo=bar', &response)
        stub.post('/', {foo: 'bar'}, &response)
        stub.post('/', {foo: 'bar', baz: 'meh'}, &response)
        stub.get('/other', &response)
        stub.get('/broken', &broken)
      end
    end
  end

  let(:options) { {} }

  extend Forwardable
  def_delegators :@conn, :get, :post

  it 'caches get requests' do
    expect(get('/').body).to eq('request:1')
    expect(get('/').body).to eq('request:1')
    expect(get('/other').body).to eq('request:2')
    expect(get('/other').body).to eq('request:2')
  end

  it 'includes request params in the response' do
    get('/') # make cache
    response = get('/')
    puts response.to_hash
    expect(response.env[:method]).to eq(:get)
    expect(response.env[:url].request_uri).to eq('/')
  end

  it 'caches requests with query params' do
    expect(get('/').body).to eq('request:1')
    expect(get('/?foo=bar').body).to eq('request:2')
    expect(get('/?foo=bar').body).to eq('request:2')
    expect(get('/').body).to eq('request:1')
  end

  it 'caches POST requests by the BODY' do
    expect(post('/', {foo: 'bar'}).body).to eq('request:1')
    expect(post('/', {foo: 'bar'}).body).to eq('request:1')
    expect(post('/', {foo: 'bar'}).body).to eq('request:1')
  end

  it 'caches posts requests by the alphabatized body params' do
    expect(post('/', {foo: 'bar', baz: 'meh'}).body).to eq('request:1')
    expect(post('/', {baz: 'meh', foo: 'bar'}).body).to eq('request:1')
  end

  it 'does not cache responses with invalid status code' do
    expect(get('/broken').body).to eq('request:1')
    expect(get('/broken').body).to eq('request:2')
  end

  class TestCache < Hash
    def read(key)
      if cached = self[key]
        Marshal.load(cached)
      end
    end

    def write(key, data)
      self[key] = Marshal.dump(data)
    end

    def fetch(key)
      read(key) || yield.tap { |data| write(key, data) }
    end
  end

  class CachingLint < Struct.new(:app)
    def call(env)
      app.call(env).on_complete do
        raise "no headers" unless env[:response_headers].is_a? Hash
        raise "no response" unless env[:response].is_a? Faraday::Response
        # raise "env not identical" unless env[:response].env.object_id == env.object_id
      end
    end
  end
end


