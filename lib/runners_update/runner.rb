module RunnersUpdate
  # ランナークラス
  class Runner
    attr_accessor :number, :name, :splits
    def initialize(number, name)
      @number = number
      @name = name
      @splits = []
    end

    # ポイントの追加
    #
    # @param [String] name 測定ポイント名
    # @param [String] split スプリットタイム
    # @param [String] lap ラップタイム
    # @param [String] pass 通過タイム
    def add_point(name, split, lap, pass)
      @splits << Point.new(name, split, lap, pass)
    end
  end

  # 測定ポイントクラス
  class Point
    attr_accessor :name, :split, :lap, :pass
    # initialize
    #
    # @param [String] name 測定ポイント名
    # @param [String] split スプリットタイム
    # @param [String] lap ラップタイム
    # @param [String] pass 通過タイム
    def initialize(name, split, lap, pass)
      @name = name
      @split = split
      @lap = lap
      @pass = pass
    end
  end
end
