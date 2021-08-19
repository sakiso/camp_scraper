class Api::Fumoto::V1::FumotoController < ActionController::API
  def index
    # ライブラリのインポート
    require 'net/http'
    require 'uri'
    require 'nokogiri'

    # 10月の土曜日のXpath定義
    xpaths = {
      date_10_02:
        '/html/body/div[1]/div[2]/div[2]/div[2]/table/tbody/tr[3]/td[3]',
      date_10_09:
        '/html/body/div[1]/div[2]/div[2]/div[2]/table/tbody/tr[10]/td[3]',
      date_10_16:
        '/html/body/div[1]/div[2]/div[2]/div[2]/table/tbody/tr[17]/td[3]',
      date_10_23:
        '/html/body/div[1]/div[2]/div[2]/div[2]/table/tbody/tr[24]/td[3]',
      date_10_30:
        '/html/body/div[1]/div[2]/div[2]/div[2]/table/tbody/tr[31]/td[3]',
    }

    # ふもとっぱら予約状況のURLにPOSTする準備
    uri = URI.parse('https://fumotoppara.secure.force.com/RS_Top')
    request = Net::HTTP::Post.new(uri)
    request.set_form_data(
      'f_nengetsu' => '2021年10月',
      'j_id0:fSearch' => 'j_id0:fSearch',
      'j_id0:fSearch:searchBtn' => '検索',
    )
    req_options = { use_ssl: uri.scheme == 'https' }

    # POSTリクエストしてスクレイピング実行
    response =
      Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
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
  def reservation_checker(reservation_html)
    if reservation_html.to_s.include?('○')
      status = '○'
    elsif reservation_html.to_s.include?('△')
      status = '△'
    elsif reservation_html.to_s.include?('×')
      status = '×'
    else
      status = nil
    end
    return status
  end
end
