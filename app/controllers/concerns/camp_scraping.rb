# 関数をいくつか作って、asagiri controllerとfumoto controllerから呼ぶ
# DRYになるように！
# ・URLパース〜リクエスト発行 httpレスポンスデータをNOKOGIRIでパースしたdocを返却
# ・与えられたdoc（NOKOGIRIでHTMLパース済み）とXPATHのハッシュをもとに、マルバツ判定してJSONをかえす
# ・（上の子モジュール）与えられたHTMLをSTRING変換して、その中に○×△があるか

class CampScraping
  def initialize(xpaths:, url:)
    @xpaths = xpaths
    @url = url
    #accessorはいらない？
  end

  def get_request_with_https
    require 'net/http'
    require 'uri'

    # 朝霧予約状況のURLにGETする準備
    uri = URI.parse(@url)
    request = Net::HTTP::Get.new(uri.path)
    req_options = { use_ssl: uri.scheme == 'https' }

    # GET
    @response =
      Net::HTTP.start(uri.host, uri.port, req_options) do |http|
        http.request(request)
      end

    return 'get request finished'
  end

  def scraping_with_xpaths
    # nokogiriでパース
    doc = Nokogiri.HTML(@response.body)

    # 予約状況を判定し{月日:○ or × or △}のハッシュ形式で返却
    reservation_status = {}
    @xpaths.each do |key, value|
      reservation_status.store(key, reservation_checker(doc.xpath(value)))
    end

    # 予約状況ハッシュ返却
    return reservation_status
    return 'scraping finished'
  end

  private

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
