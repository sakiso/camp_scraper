class Api::Fumoto::V1::FumotoController < ActionController::API
  def index
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
    url = 'https://fumotoppara.secure.force.com/RS_Top'
    post_parameter = {
      'f_nengetsu' => '2021年10月',
      'j_id0:fSearch' => 'j_id0:fSearch',
      'j_id0:fSearch:searchBtn' => '検索',
    }

    # スクレイピング対象のURLと予約状況が格納されているXpathを渡して、予約状況JSONを取得する
    reservation_status =
      CampScraping
        .new(xpaths: xpaths, url: url)
        .sraping_with_post_request(parameter: post_parameter)

    # JSON出力
    render json: reservation_status
  end
end
