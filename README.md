# semantic-release-test

semantic-release と GitHub Actions を使用することで自動で release 管理を実行してくれるかのテストを行う。

## 検証ポイント

1. main に push したら release と tag を自動で作成できるか
2. コミットメッセージの規則を強制する
3. packageにも反映できるのか（別repositoryでやるかも）

### 1. を実現するために導入するもの

- semantic-release
- GitHub Actions

### 2. を実現するために導入するもの

- commitlint
- husky

## 事前準備

### yarn を使っての環境構築

```yarn
yarn init
```

private は true にしておく。

## 各ツールの導入手順 前半

### semantic-release

```yarn
yarn add -D semantic-release
```

#### semantic-release の設定

.releaserc.json ファイルで管理する。
(package.json でも管理可能)

とりあえず、リリース管理対象のブランチ名を指定する
```json:.releaserc.json
{
  "branches": ["main"]
}
```

### ツールじゃないけど、GitHub Actions

.github フォルダ以下を参照

## ここまでの検証

semantic-release と GitHub Actions で、バージョンアップの自動化はできているはず。

- "fix: xxx" とすると、x.x.0 のバージョンが上がる -> パッチバージョンアップ
- "feat: xxx" とすると、x.0.x のバージョンが上がる -> マイナーバージョンアップ
- "BREAKING CHANGE: xxx" を、メッセージのフッターに記載すると、0.x.x のバージョンが上がる -> メジャーバージョンアップ

ということで、以下試してみましょう。

1. fix: 任意のメッセージ: https://github.com/ERP-Division/versioning-test/releases/tag/v1.0.0
2. feat: 任意のメッセージ: https://github.com/ERP-Division/versioning-test/releases/tag/v1.1.0
3. BREAKING CHANGE: 任意のメッセージ: https://github.com/ERP-Division/versioning-test/releases/tag/v2.0.0

## 各ツールの導入手順 後半

semantic-release を導入したことにより、自動バージョンアップができるようになりました。

ただ、ここまで試していただいた通り、コミットメッセージを Trigger とする仕組みであるため、
コミットメッセージが非常に重要となるので、これを制約を追加してみます。

### commitlint

まずは commitlint です。
コミットメッセージの規則チェックを実施してくれます。

例えば、接頭に feat などが無いとエラーとしてくれます。

**install**

```bash
yarn add -D @commitlint/cli @commitlint/config-conventional
```

**config**

```json:.commitlintrc.json
{
  "extends": [
    "@commitlint/config-conventional"
  ]
}
```

#### 試してみる

> echo "foo(scope): bar" | yarn commitlint

```bash
yarn run v1.22.18
$ /home/xxxxxxx/src/github.com/ERP-Division/versioning-test/node_modules/.bin/commitlint
⧗   input: foo(scope): bar
✖   Please add rules to your `commitlint.config.js`
    - Getting started guide: https://git.io/fhHij
    - Example config: https://git.io/fhHip [empty-rules]

✖   found 1 problems, 0 warnings
ⓘ   Get help: https://github.com/conventional-changelog/commitlint/#what-is-commitlint

error Command failed with exit code 1.
info Visit https://yarnpkg.com/en/docs/cli/run for documentation about this command.

```

### husky

せっかく追加した commitlist ですが、これ単独ではコミット時にチェックまではしてくれません。

これを実現するために husky を導入します。

**install**

```bash
yarn add -D husky
yarn husky install
yarn husky add .husky/commit-msg 'yarn commitlint --edit $1'
```

#### 試してみる

> git commit -m "test: test"

```bash
yarn run v1.22.18
$ /home/xxxxxxx/src/github.com/ERP-Division/versioning-test/node_modules/.bin/commitlint --edit .git/COMMIT_EDITMSG
⧗   input: test: test
✖   Please add rules to your `commitlint.config.js`
    - Getting started guide: https://git.io/fhHij
    - Example config: https://git.io/fhHip [empty-rules]

✖   found 1 problems, 0 warnings
ⓘ   Get help: https://github.com/conventional-changelog/commitlint/#what-is-commitlint

error Command failed with exit code 1.
info Visit https://yarnpkg.com/en/docs/cli/run for documentation about this command.
husky - commit-msg hook exited with code 1 (error)

```
