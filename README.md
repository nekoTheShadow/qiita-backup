# 概要

Qiitaに投稿した記事のバックアップを取得し、内容をGithub Pages & Hugoを利用して公開します。

# ブランチ

- `master` - hugoで必要なファイルおよびバックアップや記事の公開に必要なスクリプトを格納しています。
- `backup` - Qiita APIを利用して取得した記事とコメントのバックアップをJSON形式で格納しています
- `doc` - Github Pagesで公開するコンテンツを格納しています。`backup`ブランチのコンテンツを加工しhugoでビルドした内容が格納されています。

# スクリプト

- `script/backup.rb` - Qiita APIを利用して、自分の投稿した記事・コメント・画像ファイルを取得します。Qiita APIの利用に必要なアクセストークンは環境変数`QIITA_ACCESS_TOKEN`経由で受け取ります。
- `script/convert.rb` - `script/backup.rb`で取得したバックアップをもとに、hugoビルドに適した形式へ変換します。

# URL

- https://github.com/nekoTheShadow/qiita-backup
- https://nekotheshadow.github.io/qiita-backup/blog/52a1e7320c29275d5580/