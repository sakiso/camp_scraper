# モジュールをいくつか作って、asagiri controllerとfumoto controllerから呼ぶ
# DRYになるように！
# ・URLパース〜リクエスト発行 httpレスポンスデータをNOKOGIRIでパースしたdocを返却
# ・与えられたdoc（NOKOGIRIでHTMLパース済み）とXPATHのハッシュをもとに、マルバツ判定してJSONをかえす
# ・（上の子モジュール）与えられたHTMLをSTRING変換して、その中に○×△があるか
