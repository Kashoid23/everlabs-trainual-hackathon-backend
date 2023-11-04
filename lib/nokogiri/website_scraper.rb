class Nokogiri::WebsiteScraper
  def self.parse(link:)
    uri = URI(link)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.open_timeout = 240
    http.read_timeout = 240

    request = Net::HTTP::Get.new(uri)
    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      document = Nokogiri::HTML(response.body)

      Sanitize.fragment(document, elements: [], remove_contents: %w[script style]).delete!("\n").squeeze(' ')
    end
  end
end
