# はなクイズ図鑑

花の写真を見て名前を覚える、オフライン対応のFlutter MVPです。

## 主な機能

- ホーム画面で学習状況を表示
- 20種類の花データを使った4択クイズ
- 10問1セットの結果表示
- 間違えた花を優先する復習モード
- カード形式の図鑑と花の詳細画面
- SharedPreferencesによる正解数、不正解数、最終学習日時の保存

## 実行方法

Flutter SDKをインストールし、`flutter` コマンドにPATHを通したあとで実行します。

```powershell
flutter pub get
flutter create --platforms=android,ios .
flutter run
```

この環境では `flutter` / `dart` コマンドが見つからなかったため、ビルド確認は未実行です。

## 画像について

`assets/images/` にはMVP用の簡易JPEG画像を置いています。実際の花写真に差し替える場合も、同じファイル名のまま置き換えればアプリ側のコード変更は不要です。
