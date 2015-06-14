require 'runners_update/version'
require 'runners_update/client'

# ランナーズアップデートクラス
module RunnersUpdate

  # データの取得
  #
  # @param [String] race_id レースID
  # @param [Array] *args ナンバー
  # @return [Array] データ
  def self.get(race_id, *args)
    client = Client.new(race_id, *args)
    return client.get_result()
  end

end
