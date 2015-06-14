# RunnersUpdate

ランナーズアップデートのデータを取得します。ランナーズアップデートについては、[ランナーズアップデートとは - ランナーズアップデート](http://update.runnet.jp/2015chitose/help.html) を参照してください。

## インストール

Gemfile に次の行を追加します。

```ruby
gem 'runners_update', :git => 'https://github.com/kyoshidajp/runners_update.git'
gem 'mechanize'
```

そして、次のコマンドを実行します。

    $ bundle install

## 使い方

最初にレースIDを確認します。レースIDとは、レースのランナーズアップデート検索画面URLが

```
http://update.runnet.jp/2015sibamata100/
```

または

```
http://update.runnet.jp/2015sibamata100/index.html
```

の場合、`2015sibamata100` が該当します。

次に、データを取得したいランナーのナンバーをレース公式サイトの参加者名簿等を参考にして調べます。ナンバーは一人の場合は `String` または `Fixnum`、複数名の場合は `Range` の可変長引数で指定可能です。

ソースコードでは `runners_update` を `require` します。

```ruby
require 'runners_update'
```

`RunnersUpdate` の `get` メソッドに対して、レースID、ナンバーを渡します。

```ruby
result = RunnersUpdate.get(レースID, ナンバー)
```

結果は `RunnersUpdate::Runner` クラスの `Array` になっています。

## サンプル

次は2015年6月6日に行われた、[東京・柴又100K](http://tokyo100k.jp/)の結果について、ナンバー 1〜100, 1000〜1010 のデータを CSV 形式で出力するサンプル `sample.rb` です。

```ruby
require 'runners_update'
require 'csv'

ID = '2015sibamata100/' # レースID

result = RunnersUpdate.get(ID, 1..100, 1000..1010)

CSV do |writer|
  result.each do |runner|
    points = []
    runner.splits.each do |s|
      points << s.split
    end
    writer << [runner.number, runner.name].concat(points)
  end
end
```

```
$ bundle exec ruby sample.rb

... CSV形式の結果

```

## ライセンス

- [MIT License](http://opensource.org/licenses/MIT)

## 注意事項

[総合利用規約](http://runnet.jp/help/rule/detail_n6.html) の「第4条　財産権について」に記載されていますが、取得したデータを公開する事は規約に違反すると思われます。
