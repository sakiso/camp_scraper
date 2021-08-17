class Api::Fumoto::V1::FumotoController < ActionController::API
  def index
    # ライブラリのインポート
    require 'net/http'
    require 'uri'
    require 'nokogiri'

    # ふもとっぱら予約状況のURLにPOSTして予約状況のレスポンス取得
    uri = URI.parse('https://fumotoppara.secure.force.com/RS_Top')
    request = Net::HTTP::Post.new(uri)
    request.set_form_data(
      'f_nengetsu' => '2021年10月',
      'j_id0:fSearch' => 'j_id0:fSearch',
      'j_id0:fSearch:searchBtn' => '検索',
    )
    req_options = { use_ssl: uri.scheme == 'https' }
    response =
      Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end

    # nokogiriでパース
    doc = Nokogiri.HTML(response.body)
    reservation_html =
      doc.xpath(
        '/html/body/div[1]/div[2]/div[2]/div[2]/table/tbody/tr[17]/td[3]',
      )

    if reservation_html.to_s.include?('○')
      reservation_status = '○'
    elsif reservation_html.to_s.include?('△')
      reservation_status = '△'
    elsif reservation_html.to_s.include?('×')
      reservation_status = '×'
    else
      reservation_status = nil
    end

    render json: { reservation_status: reservation_status }
  end
end
