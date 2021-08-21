# 関数をいくつか作って、asagiri controllerとfumoto controllerから呼ぶ
# DRYになるように！
# ・URLパース〜リクエスト発行 httpレスポンスデータをNOKOGIRIでパースしたdocを返却
# ・与えられたdoc（NOKOGIRIでHTMLパース済み）とXPATHのハッシュをもとに、マルバツ判定してJSONをかえす
# ・（上の子モジュール）与えられたHTMLをSTRING変換して、その中に○×△があるか

class CampScraping
  def get_request_with_https(uri:)
    require 'net/http'
    require 'uri'

    # 朝霧予約状況のURLにGETする準備
    url = URI.parse(uri)
    request = Net::HTTP::Get.new(url.path)
    req_options = { use_ssl: url.scheme == 'https' }

    # GETしてスクレイピング実行
    @response =
      Net::HTTP.start(url.host, url.port, req_options) do |http|
        http.request(request)
      end

    return 'get request finished'
  end

  def scraping_with_xpaths(xpaths_hash:)
    # nokogiriでパース
    doc = Nokogiri.HTML(@response.body)

    # 予約状況を判定し{月日:○ or × or △}のハッシュ形式で返却
    reservation_status = {}
    xpaths_hash.each do |key, value|
      reservation_status.store(key, reservation_checker(doc.xpath(value)))
    end

    # 予約状況ハッシュ返却
    return reservation_status
    return 'scraping finished'
  end
end
