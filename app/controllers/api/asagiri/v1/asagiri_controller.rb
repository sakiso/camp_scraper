class Api::Asagiri::V1::AsagiriController < ActionController::API
  def index
    # ライブラリのインポート
    require 'net/http'
    require 'uri'
    require 'nokogiri'

    # 10月の土曜日のXPath定義
    xpaths = {
      date_10_02: '/html/body/div[2]/div/div[1]/div/table[3]/tr[2]/td[1]',
      date_10_09: '/html/body/div[2]/div/div[1]/div/table[3]/tr[2]/td[2]',
      date_10_16: '/html/body/div[2]/div/div[1]/div/table[3]/tr[2]/td[3]',
      date_10_23: '/html/body/div[2]/div/div[1]/div/table[3]/tr[2]/td[4]',
      date_10_30: '/html/body/div[2]/div/div[1]/div/table[3]/tr[2]/td[5]',
    }

    # 朝霧予約状況のURLにGETする準備
    url = URI.parse('https://www.asagiri-camp.net/reservation.html')
    request = Net::HTTP::Get.new(url.path)
    req_options = { use_ssl: url.scheme == 'https' }

    # GETしてスクレイピング実行
    response =
      Net::HTTP.start(url.host, url.port, req_options) do |http|
        http.request(request)
      end

    # nokogiriでパース
    doc = Nokogiri.HTML(response.body)

    # 予約状況を判定しハッシュ形式で返却
    reservation_status = {}
    xpaths.each do |key, value|
      reservation_status.store(key, reservation_checker(doc.xpath(value)))
    end

    # JSON出力
    render json: reservation_status
  end

  # 与えられたHTML要素に予約状況を示す記号が含まれていればその記号を返す
  # ○と×は似た別の文字があるので表記ゆれ対策している
  def reservation_checker(reservation_html)
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
