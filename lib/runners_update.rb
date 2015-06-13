require 'runners_update/version'
require 'runners_update/client'

# ランナーズアップデートクラス
module RunnersUpdate

  # データの取得
  #
  # @param [String] race_id レースID
  # @param [Array] ranges ナンバーRangeのArray
  # @return [Array] データ
  def self.get(race_id, ranges)
    client = Client.new(race_id, ranges)
    return client.get_result()
  end

end
