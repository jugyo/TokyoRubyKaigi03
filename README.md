=東京RubyKaigi03 ワークショップ

---

==概要
Sinatra + herokuで簡単なtwitterクローンを作ってみる

==講師
1.tsuyoshikawa
  これらのドキュメントとコードの作成と、当日の進行役をやります
2.jugyo
  受講者のバックアップです。主に当日のコードの見守り役をやります

==環境
-ruby 1.8.7 (2010-01-10 patchlevel 249)
-gem 1.3.6

==必要なライブラリ
  -sinatra (0.9.4)
  -dm-core (0.10.2)
  -dm-timestamps (0.10.2)
  -do_sqlite3 (0.10.1.1)
  -unicorn (0.96.1)

下記のコマンドで一発で準備出来るでしょう
sudo gem install sinatra dm-core dm-timestamps do_sqlite3 unicorn --no-rdoc --no-ri

==参考URL
-Sinatra 日本語ガイド
http://www.sinatrarb.com/intro-jp.html

-DataMapper Documentations
http://datamapper.org/docs/

-Heroku Docs&FAQs
http://docs.heroku.com/

==伝えたいこと
Sinatraで小物の開発はすごい楽
herokuがあるので商用ではテスト環境に、プライベートならそのまま開発して公開まで出来てしまう

==ハマりポイント
-dm-*とdo_*はそれぞれバージョンをそろえること。
-herokuにあるdm-coreとdo_*のバージョンは、0.9.11
 なので、DataMapperの関連周りが全然動かない。
 herokuのENV['DATABASE_URL']にはheroku内のデータベース(postgres)のURL情報が設定されてあり、
 do_*系のバージョンアップも不可能なため、DataMapperのアップグレードをherokuがしてくれる日を待つほか無い
