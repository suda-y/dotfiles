# My dotfiles - 私的ドットファイル（設定ファイル）

## github 認証で躓いたところ

token を入力って言われて素直に設定した token を入力していたが、生成されたトークンを入力しないとダメ

git-credential-manager-core をインストール
上記のGCMを使用する設定
git config --global credential.helper manager
