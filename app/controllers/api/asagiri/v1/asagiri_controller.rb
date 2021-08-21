class Api::Asagiri::V1::AsagiriController < ActionController::API
  def index
    # 10月の土曜日のXPath定義
    xpaths = {
      date_10_02: '/html/body/div[2]/div/div[1]/div/table[3]/tr[2]/td[1]',
      date_10_09: '/html/body/div[2]/div/div[1]/div/table[3]/tr[2]/td[2]',
      date_10_16: '/html/body/div[2]/div/div[1]/div/table[3]/tr[2]/td[3]',
      date_10_23: '/html/body/div[2]/div/div[1]/div/table[3]/tr[2]/td[4]',
      date_10_30: '/html/body/div[2]/div/div[1]/div/table[3]/tr[2]/td[5]',
    }

    # 朝霧ジャンボリーの予約状況URL
    url = 'https://www.asagiri-camp.net/reservation.html'

    # スクレイピング対象のURLと予約状況が格納されているXpathを渡して、予約状況JSONを取得する
    reservation_status =
      CampScraping.new(xpaths: xpaths, url: url).sraping_with_get_request

    # JSON出力
    render json: reservation_status
  end
end
