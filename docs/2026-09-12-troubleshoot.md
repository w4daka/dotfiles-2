## 要約（Executive Summary）

**事象（Incident）**: `home-manager switch --flake .` が2件の評価エラーで失敗した
**日時（Date/Time）**: 2026-09-12 14:34 JST 〜 15:04 JST 頃
**継続時間（Duration）**: 約30分 (第二障害)。第一障害を含めると 2026-09-06 〜 09-12 の断続
**深刻度（Severity）**: 低 (個人 dotfiles、外部顧客なし)

**概要（Summary）**
fetchFromGitHub の `hash` が SRI 形式でなかったため評価に失敗し、修正後に別件の参照切れ (`home-manager/git/.gitconfig` が削除済みなのに `home.nix` が参照) が顕在化した。前者は `sha256-` 接頭辞付与と `cargoHash` 確定で、後者はファイル復元で解消した。

---

## タイムライン（時系列）（Timeline）

時刻はすべて JST 表記。

| 時刻（Time） | 出来事（Event） | 担当者・主体（Actor） |
|------|-------|-------|
| 2026-08-31 10:22 | `fa93d1d` で `~/.gitconfig` を `home-manager/git/.gitconfig` として取込、`home.nix` から参照開始 | 運用者 |
| 2026-09-06 15:14〜15:37 | `markdown-reader` カスタムパッケージ追加。`hash` を接頭辞なし base64、`cargoHash = lib.fakeHash` で仮置き | 運用者 |
| 2026-09-12 14:34 | `d5b0758` で `AGENTS.md` 整備と同時に `home-manager/git/.gitconfig` を誤削除。`home.nix:60` の参照は残存 | 運用者 (コミット分割漏れ) |
| 2026-09-12 14:53 | `1fd0f87` で `hash` を `sha256-x5aob...` に修正、`version` を `1.35.1+<rev>` に変更 | 運用者 + 調査支援 |
| 2026-09-12 15:01 | `d39e0b0` で `.gitconfig` を復元 (`[user]` 3行、`fa93d1d` と同一) | 運用者 |
| 2026-09-12 15:04 | `ba36691` で `cargoHash` を確定値 `sha256-Ujck...` に更新 | 運用者 |
| 2026-09-12 15:41 | `c9f7845` で空の `docs/2026-09-12-troubleshoot.md` を作成 | 運用者 |

**重要な局面（Key Moments）**
- **引き金（Trigger）**: `d5b0758` の無関係ファイル削除、および旧式 `hash` 記述
- **検知（Detection）**: `home-manager switch --flake .` の手動実行時のエラー文
- **被害拡大防止（Mitigation）**: `git log -- home-manager/git/.gitconfig` と `git show d5b0758` で削除コミットを特定した時点
- **解消（Resolution）**: `.gitconfig` 復元 + `hash`/`cargoHash` 確定後、`switch` 評価が通過した時点

---

## 影響（Impact）

**顧客影響（Customer Impact）**
- 影響ユーザー数（Users affected）: 1名 (本人)
- 影響継続時間（Duration of impact）: 新規 generation 作成不可の期間。既存 `~/.gitconfig` symlink (旧 store 参照) は残存したため即時業務停止には至らない
- 症状（Symptoms experienced）: `switch` が `derivationStrict` / `home-manager-generation` 経由で失敗する。1件目は `hash ... does not include a type`、2件目は `Path 'home-manager/git/.gitconfig' does not exist in Git repository`

**事業影響（Business Impact）**
- 売上影響（Revenue impact）: なし
- SLA/SLO違反（SLA/SLO breach）: なし

---

## 根本原因分析（Root Cause Analysis）

**根本原因（Root Cause）**
- 仕組みが参照整合性を保証していない。Nix flake は git 管理ファイルのみを評価するのに、`home.nix` の相対パス参照と実ファイルの有無を結ぶ検査がコミット前に存在しない
- Nixpkgs の現行 fetcher が `hash` 引数に SRI (`sha256-...`) を要求する変更に対し、旧式の素の base64 記述が残っていた

**引き金（Trigger）**
- `d5b0758` での `.gitconfig` 削除
- `fetchFromGitHub { hash = "x5aob..."; }` という型情報なし記述

**寄与要因（Contributing Factors）**
| 要因（Factor） | どう寄与したか（How It Contributed） |
|--------|-------------------|
| 無関係変更の同梱コミット | `AGENTS.md` 整備コミットに削除が混入し、レビューで見落とされた |
| `version = "master"` の初期値 | 可変名で内容を特定できず、hash 誤りに気づきにくかった。後に `1.35.1+<rev>` に是正 |
| ディレクトリ名 typo (`markdwon-reader`) | 探索・一貫性低下の要因。直接原因ではない |
| `cargoHash = lib.fakeHash` の仮置き長期化 | 意図的失敗状態が残り、エラー切り分けを複雑にした |
| 空レポートの先行コミット | `c9f7845` で 0 バイト md を作成し、記録が後回しになった |

**なぜ検出できなかったのか（Why Wasn't This Caught?）**
- switch 前の検査 (`git status`、`nix flake check`、`--show-trace eval`) が手順化されていない
- CI がなく、手動 `switch` のみが検出手段である
- `warning: builtins.derivation ... options.json` の警告が常態化し、評価系の異常感度が下がっていた

---

## うまくいったこと（What Went Well）

| うまくいったこと（What Worked） | どう役立ったか（Why It Helped） |
|-------------|---------------|
| mcp_nixos と Nix 実装 (`hash.cc`) の照合 | `hash`/`sha256` 引数の違いと SRI 要件を断定できた |
| `git log -- <path>` と `git show` による特定 | 削除コミット `d5b0758` と復元元 `fa93d1d` を即時特定できた |
| 最小差分での復元選択 | `programs.git` 移行案を退け、配置先変更の副作用を避けて早期復旧できた |

---

## うまくいかなかったこと（What Failed）

| 失敗したこと（What Failed） | 影響（Impact） |
|-------------|--------|
| 削除と参照残存の同時コミット | 第二障害の直接原因。switch 不可になった |
| hash 修正が接頭辞付与のみで prefetch 検証なし | 誤 hash のまま先送りになり、`cargoHash` 問題と多重化した |
| 障害記録ファイルの空コミット | 事後記録が遅れ、時系列の再構成コストが増えた |

---

## 対応項目（Action Items）

**応急対応（Immediate）**
| 対応（Action） | 担当者（Owner） | 期限（Due） |
|--------|-------|-----|
| 本レポートを `docs/2026-09-12-troubleshoot.md` に記録する | w4daka | 2026-09-13 |
| `home-manager switch --flake . --show-trace` の成功を再確認する | w4daka | 2026-09-13 |

**短期（Short-term）**
| 対応（Action） | 担当者（Owner） | 期限（Due） |
|--------|-------|-----|
| コミット前に `git status --short` と `nix flake check` を実行する手順を `AGENTS.md` に追記する | w4daka | 2026-09-20 |
| 1コミット1目的を徹底し、AGENTS 整備と dotfiles 変更を分離する | w4daka | 2026-09-20 |
| `markdwon-reader` typo の改名可否を検討する | w4daka | 2026-09-30 |
| `programs.git` 移行の再検討 (XDG 移行含む) を別課題化する | w4daka | 2026-09-30 |

---

## 学び・要点（Lessons Learned）

1. flake の `./path` 参照は git 管理状態と一体である。`git add` 漏れ・誤削除は即評価失敗になるため、switch 前に `git status` と `git ls-files` で確認する
2. `fetchFromGitHub.hash` は SRI (`sha256-...`) が正規であり、素の base64 は使えない。`sha256 = "..."` は旧式であり、新規は `hash` + SRI に統一する
3. 無関係変更の同梱は根本原因特定を遅らせる。ドキュメント整備と機能変更は分離する
