require 'nokogiri'
require 'net/http'
require 'uri'
require 'cgi'

def fetch(target_url, limit = 10)
  raise 'HTTP redirect stack depth exceeded!' if limit == 0

  begin
    uri = URI.parse(target_url)
    cookie =
      CGI::Cookie.new(
        'name' => 'session',
        'value' => ['53616c7465645f5f8d7038eec14bb54d1fea7e05842a1a9f287c8f325298a070920a4e0b0e6bd6338bedfce9b56fbf15'],
        'domain' => 'HttpOnly_.adventofcode.com',
        'httponly' => true
      )
    # cookie = CGI::Cookie.parse(File.read('cookies.txt'))
    p cookie

    request = Net::HTTP::Get.new(uri)
    request["User-Agent"] = 'myAoCgetter'
    request['Cookie'] = cookie.to_s.sub(/; path=$/, '')

    req_options = {
      use_ssl: uri.scheme == "https"
    }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    case response.code
    when /2\d\d/
      response
    when '301'
      fetch(response['location'], limit - 1)
    else
      raise response.body
      # response.error!
    end
  rescue Errno::ECONNREFUSED
    raise "\033[31mConnection refused while trying to get #{target_url}.\033[0m"
  end
end

def fetch_doc(url)
  response = fetch(url)
  html = response.body
  doc = Nokogiri::HTML(html)
  doc.remove_namespaces!

  doc
end

puts fetch_doc('https://adventofcode.com/2020/day/1').css("article.day-desc").each{|dd|puts dd.css("h2").text; dd.css("p").each{|p|puts p.text}}
