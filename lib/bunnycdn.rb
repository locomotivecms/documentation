require 'uri'
require 'net/http'

class Bunnycdn

  attr_reader :access_key

  def initialize(access_key:)
    @access_key = access_key
  end

  def purge(zone_id)
    url = URI("https://api.bunny.net/pullzone/#{zone_id}/purgeCache")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["content-type"] = 'application/json'
    request["AccessKey"] = access_key

    response = http.request(request)

    if response.code_type.to_s != 'Net::HTTPNoContent'
      puts "🚨 Unable to purge the cache"
    end
  end
end
