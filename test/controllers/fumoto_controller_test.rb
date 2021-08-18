require 'test_helper'

class FumotoControllerTest < ActionDispatch::IntegrationTest
  test 'ふもとっぱらの予約状況を取得する' do
    get api_fumoto_v1_check_reservation_url
    assert_not JSON.parse(response.body) == nil
    assert response.status == 200
  end
end
