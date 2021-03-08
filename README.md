# エンジニアコードチェック課題　回答

## 注意事項

1. developブランチでお願いします。まだmainにはマージしていません。
2. cocoaPodsを導入したので、 `pod install` をお願いします。
3. Issue順に終わらせてないので、commitが順不同です。  
Commitコメントに `refs #[Issue番号]` で、該当と思われるIssueを記述しています。

## Issue毎の対応内容

### #2 ソースコードの可読性の向上
- swiftLintライブラリを導入
  - 命名規約違反の解消
- MARKの追加
- メソッド化
- 不要な変数、コメントの削除
- ViewControllerのクラス名修正
  - リスト画面：ViewController → ListViewController
  - 詳細画面：ViewController2 → DetailViewController

### #３ ソースコードの安全性の向上
- 強制アンラップの解消
- 不必要なIUOの解消
- privateの明示
- クロージャー内を弱参照に変更

### #４ バグを修正
- パースエラーの解消
  - watchers_countのスペルミス
  - stargazers_countとstargazers_countが同じ値（APIエラー？）が解消していません。
- レイアウトの修正
  - リスト画面にLanguageが表示されていなかったので修正。
  - 詳細画面のAuteLayoutの修正。

### #５ Fat VC の回避
- API取得データをモデル化

### #６ プログラム構造をリファクタリング
- 全体的にメソッドの整理
- 画面遷移時の値渡しを修正

### #７ アーキテクチャを適用
- MVC(っぽく)修正
  - アーキテクチャを自身で選定したことがなかったので、自信がないです。
  - アプリの規模と修正工数から、MVCを選択しました。

### #8 UI をブラッシュアップ
- アイコンを追加
- テーマカラーを黒白に変更
- 取得データ部分がみやすくなるように太字に変更

### #9 新機能を追加
- 検索履歴機能を追加
  - HistoryViewControllerの追加
  - 履歴は暫定的にUserDefaultsで保存しています。
- 検索のtotal_countを表示
- 検索中のIndicatorを表示（機能ではないかも？）
- APIのレスポンスが30件だったので、tableViewを1番下までスクロールしたら、続きを読み込む処理を追加

### #10 テストを追加
- UITest、UnitTest追加
  - 今まで作成したことがなかったので、探り探り作ってみましたが、全く自信がないです。
