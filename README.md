# My dotfiles - 私的ドットファイル（設定ファイル）

## github 認証で躓いたところ

token を入力って言われて素直に設定した token を入力していたが、生成されたトークンを入力しないとダメ

## GitHubで認証時の個人アクセストークンを記憶させる
### はじめに
 いちいち毎回トークンを手打ちしたくない
### 入力した認証情報を保存する
#### 常駐プロセスに一時記憶 (cache)
cache 方式は標準で付属しています。
以下のコマンドで cache 方式が使用できます。
```
git config --global credential.helper cache
```
初回にトークン入力時にgit-credential-cache--daemon プロセスが常駐して、タイムアウト時間が過ぎるまでトークンを記憶します。

タイムアウトは、デフォルトで900秒(15分)です。変更するには、次のようにタイムアウト時間(例では3,600秒)を指定します。
```
git config --global credential.helper 'cache --timeout=3600'
```

#### ファイルに保存 (平文)
```
git config --global credential.helper store
```

保存先は指定できるが無指定だと`~/.git-credentials`に保存される。

```
git config --global credential.helper 'store --file ~/.gitr_credentials'
```
上記のように保存先を指定することも出来る。

#### Git Credential Manager Core を使って認証情報を管理する
##### Git Credentail Manager Core をインストール
と、いうことで[Git Credential Manager Core](https://github.com/GitCredentialManager/git-credential-manager)をインストールする。

1. Linuxの場合<br>
  最新の[debパッケージ](https://github.com/GitCredentialManager/git-credential-manager/releases/latest)をダウンロードして、以下を実行します。
```
sudo dpkg -i <path-to-package>
git-credential-manager-core configure		# 認証情報を登録
```
アンインストールするには以下の通り:
```
git-credential-manager-core unconfigure
sudo dpkg -r gcmcore
```
2. Windows の場合 (scoop使用)<br>
scoop で git-credential-manager-core をインストール
```
scop install git-credential-manager-core
```
MSYS2 で使用するために /usr/local/bin にコピー
```
cp ${USERPROFILE}/scoop/shims/git-credential-manager-core.* /usr/local/bin/
git-credential-manager-core configure		# 認証情報を登録
```

git-credential-manager-core をインストール
上記の[GCM Core](https://github.com/GitCredentialManager/git-credential-manager)
を使用する設定
##### Git Credentail Manager Core を使うように設定

```
git config --global credential.helper manager
```

# Gitコマンドについて
## 基本操作のコマンド
- 環境設定
```
# ユーザ名設定
$ git config --global user.name "yuji.suda"
```

- リポジトリ作成
```
# カレントディレクトリをGitリポジトリとして初期化する。
$ git init

# リモートリポジトリをローカルにクローン（複製）する。
$ git clone https://github.com/suda-y/gettest.git
```

- ファイル管理
```
# ファイルをインデックスに登録する。（バージョン管理対象になる）
$ git add <pathspec>

# ファイル名変更、移動
$ git mv <source> <destination>

# ファイルをバージョン管理から除外する
$ git rm <pathspec>
```

- ステータスと差分の確認
```
# 現時点作業ツリー内の状態を確認する。
$ git status

# コミットや作業ツリーとの差分を表示する。
$ git diff

# コミットの差分、ファイルの内容を表示する。
$ git show <commit>
```
- コミット
```
# インデックスに変更内容を登録する。
$ git add <file>

# インデックスの内容をローカルリポジトリにコミットする。
$ git commit
```
- 取り消し
```
# ファイルの変更やコミットをリセットする。（※git addの取り消しも使える）
$ git reset [--mixed | --hard | --soft] [<commit>][<file>]

# コミットの内容を取り消す。
$ git revert [--no-edit] [-n] <commit>...
```

## 共有リポジトリ（リモート）でのチーム作業のコマンド
- 変更を公開する
```
# ローカルの変更を共有リポジトリに反映する。
$ git push
```
- 共有リポジトリの変更を取り込む
```
# 共有リポジトリの変更を取得して、作業ツリーに取り組む。
$ git pull

# 共有リポジトリの変更を取得する。（取り込みはしない。変更を確認してから手動で取り込むことが多い。）
$ git fetch
```
- 変更をマージする
```
# 他のブランチの変更をチェックアウトしているブランチにマージする。
$ git merge <branch_name>

# 競合がある場合、競合を手動で解決して、再度コミット
$ git add <conflict_file>
$ git commit
```
- 変更をリベースする
```
# 他のブランチの変更をチェックアウトしているブランチにマージする。
$ git rebase <branch_name>

# 競合がある場合、競合を手動で解決して続行
$ git rebase --continue
```
- 特定のコミットをブランチに取り込む
```
# 他のブランチの変更をチェックアウトしているブランチにマージする。
$ git cherry-pick <commit_id>...
```

## その他
- ブランチ作成
```
$ git checkout -b <new_branch_name>
```
- ブランチ・タグの切り替え
```
$ git checkout <branch_name>
```
- リビジョンにタグ付け
```
$ git tag v1.0
```
- 履歴
```
$ git log

# 前の5件概要のみ表示する。
$ git log -5 --oneline
```
- 一時保存
```
# 現在編集中のファイルを一時保管
$ git stash

# 一時保管した利すとを確認する。
$ git stash list

# 一時保管した内容を確認する。
$ git stassh show <stash_id> [--name-only]

# 一時保管した内容を取り出す。
$ git stash pop
```
