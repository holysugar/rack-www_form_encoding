$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rack/www_form_encoding'
require 'minitest/autorun'
require 'rack/mock'

class Rack::WWWFormEncodingTest < Minitest::Test
  def app(encoding = Encoding::Windows_31J)
    @app = lambda { |env|
      params = env['rack.input'].string
      query  = env['QUERY_STRING'] || ""
      [200, { 'Content-Type' => 'text/plain' }, [query + params]]
    }
    Rack::WWWFormEncoding.new(@app, encoding)
  end

  def input_non_utf8
    #"name=%s" % URI.encode_www_form_component('日本語'.encode(Encoding::Windows_31J))
    'name=%93%FA%96%7B%8C%EA&foo=bar'
  end

  def test_that_it_has_a_version_number
    refute_nil ::Rack::WWWFormEncoding::VERSION
  end

  def test_it_converts_encoding_in_www_form_urlencoded_string_in_post_body
    enc = Encoding::Windows_31J
    res = Rack::MockRequest.new(app(enc)).post("/", input: input_non_utf8)
    assert_equal 'name=%E6%97%A5%E6%9C%AC%E8%AA%9E&foo=bar', res.body
  end

  def test_it_ignores_conversion_if_unmatched_encoding
    res = Rack::MockRequest.new(app(Encoding::UTF_16)).post("/", input: input_non_utf8)
    assert_equal 'name=%93%FA%96%7B%8C%EA&foo=bar', res.body
  end

  def test_it_converts_encoding_in_www_form_urlencoded_string_in_query_string
    enc = Encoding::Windows_31J
    res = Rack::MockRequest.new(app(enc)).get("/?#{input_non_utf8}")
    assert_equal 'name=%E6%97%A5%E6%9C%AC%E8%AA%9E&foo=bar', res.body
  end

  def test_it_ignores_conversion_if_unmatched_encoding_in_query_string
    res = Rack::MockRequest.new(app(Encoding::UTF_16)).post("/?#{input_non_utf8}")
    assert_equal 'name=%93%FA%96%7B%8C%EA&foo=bar', res.body
  end

end
