class Api::Asagiri::V1::AsagiriController < ActionController::API
  def index
    # ライブラリのインポート
    require 'net/http'
    require 'uri'
    require 'nokogiri'

    url = URI.parse('https://www.asagiri-camp.net/reservation.html')
    request = Net::HTTP::Get.new(url.path)
    req_options = { use_ssl: url.scheme == 'https' }
    response =
      Net::HTTP.start(url.host, url.port, req_options) do |http|
        http.request(request)
      end

    render json: { stub: 'this is stub' }
  end
end
