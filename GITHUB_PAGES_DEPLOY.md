# GitHub Pages Deploy

このプロジェクトは GitHub Actions で Flutter Web をビルドし、GitHub Pages に公開できます。

## 初回だけ必要な設定

1. GitHubにリポジトリを作成する。
2. このプロジェクトをそのリポジトリにpushする。
3. GitHubのリポジトリ画面で `Settings` > `Pages` を開く。
4. `Build and deployment` の `Source` を `GitHub Actions` にする。
5. `Actions` タブで `Deploy Flutter Web to GitHub Pages` が成功するのを待つ。

## 公開URL

通常のリポジトリなら次の形式です。

```text
https://<GitHubユーザー名>.github.io/<リポジトリ名>/
```

ユーザーサイト用リポジトリ `<GitHubユーザー名>.github.io` に置いた場合は次の形式です。

```text
https://<GitHubユーザー名>.github.io/
```

## 以後の更新

`master` または `main` にpushすると、自動でWeb版が再ビルドされて公開されます。
