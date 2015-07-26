require 'logger'
require 'mechanize'
require 'runners_update/runner'

module RunnersUpdate
  BASE_URL = 'http://update.runnet.jp/'
  class Client
    # キャッシュディレクトリ
    CASHE_DIR = 'cache'

    # ログ・ファイル
    LOG = 'log'

    # initialize
    #
    # @param [String] race_id レースID
    # @param [Array] *args ナンバー
    def initialize(race_id, *args)
      @agent = Mechanize.new
      @url = File.join(RunnersUpdate::BASE_URL, race_id)
      @ranges = *args
      @logger = Logger.new(LOG)
      @cache_dir = File.join(Dir.pwd, CASHE_DIR, race_id)
    end

    # 結果データを取得
    #
    # @return [Array] 結果データ
    def result
      result = []

      @ranges.each do |r|

        if r.instance_of?(Fixnum) || r.instance_of?(String)
          result << _result(r.to_s)
          next
        end

        unless r.instance_of?(Range)
          @logger.error("Illigal number #{r}")
          next
        end

        r.each do |n|
          runner = _result(n.to_s)
          unless runner.nil?
            result << runner
          end
        end
      end

      return result.compact
    end

    private

    # キャッシュを取得
    #
    # @param [String] number ナンバー
    # @return [Mechanize::Page|nil] 結果ページデータ
    def cache(number)
      number_file = File.join(@cache_dir, number + '.html')
      if File.exist?(number_file)
        @logger.info("Found cache at #{number_file}")
        return @agent.get("file://#{number_file}")
      end
      return nil
    end

    # ランナーが存在するか
    #
    # @param [String] number ナンバー
    # @return [Boolean] 存在するか
    def exist_runner?(number)
      number_file = File.join(@cache_dir, number + '_error.html')
      if File.exist?(number_file)
        @logger.info("Found cache at #{number_file}")
        return true
      end
      return false
    end

    # 結果ページデータを取得
    #
    # @param [String] number ナンバー
    # @return [Mechanize::Page|nil] 結果ページデータ
    def page(number)
      cache = cache(number)
      unless cache.nil?
        return cache
      end

      if exist_runner?(number)
        return nil
      end

      search_page = @agent.get(@url)

      # レースデータ取得エラー
      if search_page.uri.path == '/record'
        raise(RaceError.new(@url))
      end

      form = search_page.forms[0]
      form.number = number
      result_page = @agent.submit(form)
      return mkcache(result_page, number)
    end

    # キャッシュを作成
    #
    # @param [Mechanize::Page] result_page Mechanize:Page
    # @param [String] number ナンバー
    def mkcache(result_page, number)
      mkcache_dir

      @logger.info("Download #{result_page.uri.path}")

      # ランナーデータエラー（存在しない）でもキャッシュを作成する
      if File.basename(result_page.uri.path) == 'number_error.html'
        number_file = File.join(@cache_dir, "#{number}_error.html")
        @agent.download(result_page.uri.path, number_file)
        return nil
      end

      number_file = File.join(@cache_dir, "#{number}.html")
      @agent.download(result_page.uri.path, number_file)
      return result_page
    end

    # キャッシュディレクトリを作成
    #
    def mkcache_dir
      unless Dir.exist?(CASHE_DIR)
        Dir.mkdir(CASHE_DIR)
      end

      unless Dir.exist?(@cache_dir)
        Dir.mkdir(@cache_dir)
      end
    end

    # ランナーの結果データを取得
    #
    # @param [String] number ナンバー
    # @return [Runner] 結果データa
    def _result(number)
      page = page(number)

      # 取得出来ず
      if page.nil?
        return nil
      end

      name = page.at('div#personalBlock/dl/dd').text.sub('： ', '')

      runner = Runner.new(number, name)
      trs = page.search('table.sarchList/tr[@align="center"]')
      trs.each  do |tr|
        tds = tr.xpath('td')
        name, split, lap, pass = tds.map(&:text)
        runner.add_point(name, split, lap, pass)
      end

      return runner
    end
  end

  # レース結果取得エラークラス
  #
  # 公開が終了または存在しないレースIDの場合
  class RaceError < StandardError
    attr_reader(:url)

    # initialize
    #
    # @param [String] url URL
    #
    def initialize(url)
      @url = url
      super("Cant't get #{url}. Probably race url is closed or not exist.")
    end
  end
end
