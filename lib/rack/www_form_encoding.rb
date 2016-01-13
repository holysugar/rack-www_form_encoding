require 'rack/www_form_encoding/version'
require 'uri'

module Rack
  class WWWFormEncoding

    def initialize(app, encoding)
      @app = app
      @encoding = encoding
    end

    def call(env)
      post_body = env['rack.input'].read
      converted = convert_form(post_body, @encoding)
      env['rack.input'] = StringIO.new(converted)

      env['QUERY_STRING'] = convert_form(env['QUERY_STRING'], @encoding)

      @app.call(env)
    end

    private

    def convert_form(params_string, encoding)
      return unless params_string
      params = URI.decode_www_form(params_string, @encoding)
      params.map!{|k,v| [k, encode(v)] }
      URI.encode_www_form(params)
    end

    def encode(string)
      string.encode(Encoding::UTF_8)
    rescue EncodingError => e
      string.b
    end
  end
end
