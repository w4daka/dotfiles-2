# w4daka-dotfiles

## Home Manager 初回移行

この設定は 主要な`~/.config/`以下のディレクトリと`~/.zshrc` や`.gitconfig`を Home Manager で管理します。

既存のシンボリックリンクがある場合は、`home-manager switch` の前に移動または削除してください。

既存の通常ファイルまたはディレクトリをバックアップする場合は、次を実行してください。

```sh
home-manager switch --flake .#w4daka -b backup
