class CampScraping
  def initialize(xpaths:, url:)
    @xpaths = xpaths
    @url = url
  end

  def sraping_with_get_request
    get_request_with_https
    return scraping_with_xpaths
  end

  def sraping_with_post_request(parameter:)
    post_request_with_https(parameter: parameter)
    return scraping_with_xpaths
  end

  private

  def get_request_with_https
    require 'net/http'
    require 'uri'

    # 予約状況のURLにGETする準備
    uri = URI.parse(@url)
    request = Net::HTTP::Get.new(uri.path)
    req_options = { use_ssl: uri.scheme == 'https' }

    # GET
    @response =
      Net::HTTP.start(uri.host, uri.port, req_options) do |http|
        http.request(request)
      end
  end

  def post_request_with_https(parameter:)
    require 'net/http'
    require 'uri'

    # 予約状況のURLにPOSTする準備
    uri = URI.parse(@url)
    request = Net::HTTP::Post.new(uri)
    request.set_form_data(parameter)
    req_options = { use_ssl: uri.scheme == 'https' }

    # POST
    @response =
      Net::HTTP.start(uri.host, uri.port, req_options) do |http|
        http.request(request)
      end
  end

  def scraping_with_xpaths
    require 'nokogiri'

    # nokogiriでパース
    doc = Nokogiri.HTML(@response.body)

    # 予約状況を判定し{月日:○ or × or △}のハッシュ形式で返却
    reservation_status = {}
    @xpaths.each do |key, value|
      reservation_status.store(key, reservation_checker(doc.xpath(value)))
    end

    # 予約状況ハッシュ返却
    return reservation_status
  end

  def reservation_checker(reservation_html)
    # 与えられたHTML要素に予約状況を示す記号が含まれていればその記号を返す
    # ○と×は似た別の文字があるので表記ゆれ対策している
    html_str = reservation_html.to_s

    if html_str.include?('○') || html_str.include?('◯')
      status = '○'
    elsif html_str.include?('△')
      status = '△'
    elsif html_str.include?('✕') || html_str.include?('×')
      status = '×'
    else
      status = nil
    end
    return status
  end
end
