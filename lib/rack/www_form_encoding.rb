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

      unless env['CONTENT_TYPE'] && env['CONTENT_TYPE'].start_with?("multipart/form-data;")
        converted = convert_form(post_body, @encoding)
        env['rack.input'] = StringIO.new(converted)
      end

      env['QUERY_STRING'] = convert_form(env['QUERY_STRING'], @encoding)

      @app.call(env)
    end

    private

    def convert_form(params_string, encoding)
      return params_string unless params_string
      params = URI.decode_www_form(params_string, @encoding)
      params.map!{|k,v| [k, encode(v)] }
      URI.encode_www_form(params)
    rescue ArgumentError => e # the input of decode_www_form must be ASCII only string
      params_string
    end

    def encode(string)
      string.encode(Encoding::UTF_8)
    rescue EncodingError => e
      string.b
    end
  end
end
