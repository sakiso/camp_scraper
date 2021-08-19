require 'test_helper'

class AsagiriControllerTest < ActionDispatch::IntegrationTest
  test '朝霧ジャンボリーの予約状況を取得する' do
    get api_asagiri_v1_check_reservation_url
    assert_not JSON.parse(response.body) == nil
    assert response.status == 200
  end
end
