# AGENTS.md

## リポジトリ概要

- [ nix-communit/home-manager ](https://github.com/nix-community/home-manager)をベースにしたdotfiles

- スタンドアロンHome-managerのみ現在はサポートしている。

### ディレクトリ構成

- `/home-manager/` ユーザー環境の設定と実際のdotfiles

- `flake.nix` Home Manager 本体やインストールするパッケージの管理をする

- `flake.lock` flake.nixで`input`で定義した情報ベースに参照先を固定する。

- `README.md` Home Manager 初回移行などが書いてある。

## 主要コマンド
変更ファイルを`git add`および `git commit`してから

```shell
home-manager switch --flake .
```


