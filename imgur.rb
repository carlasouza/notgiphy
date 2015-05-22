require 'net/http'
require 'net/https'
require 'json'

class Imgur
  def self.search term
    headers    = {
      "Authorization" => "Client-ID #{ENV['IMGUR_APP_ID']}"
    }
    path = "/3/gallery/search/viral?q_all=#{URI.escape(term)}"
    uri = URI.parse("https://api.imgur.com"+path)
    request, data = Net::HTTP::Get.new(path, headers)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    response = JSON.parse http.request(request).body
    response['success'] ? response : response['status']
  end

  def self.nsfw res
    res['data'].select{|i| i if i['nsfw']}
  end

  def self.sfw res
    res['data'].select{|i| i unless i['nsfw']}
  end

  def self.gifs q
    sfw(search(q)).select {|item| item['link'] if item['animated']}
  end
end
