require 'net/http'
require 'json'

class GoogleBooksApi
  HOST = 'https://www.googleapis.com'
  API = 'books'
  VERSION = 'v1'

  API_METHODS = {
    search: 'volumes'
  }

  REPONSE_ITEMS_KEY = 'items'

  attr_accessor :api_key

  def initialize(api_key)
    self.api_key = api_key
  end

  def search_books(text)
    array_of_books = Array.new

    JSON.parse(search(text))[REPONSE_ITEMS_KEY]
  end

private

  def search(text)
    http, request = build_request(API_METHODS[:search], text)
    response = http.request(request)

    return response.body
  end

  def build_request(api_method, text)
    uri = URI.parse([HOST, API, VERSION, api_method].join('/'))
    params = { key: api_key, q: text }

    uri.query = URI.encode_www_form(params)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    return http, Net::HTTP::Get.new(uri.request_uri)
  end
end