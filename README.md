# WheelZoom

**Control + mouse wheel zoom for Apple Numbers on macOS.**

[日本語](#日本語) · [English](#english)

> **Source-code preview:** This repository currently provides the Xcode project and Swift source code. No signed or notarized application download is available yet.

## 日本語

WheelZoomは、一般的なホイール付きマウスを使って、Apple Numbersのシート表示倍率を変更するためのmacOSメニューバーアプリです。

### 主な機能

- Numbersが前面にあるときに、**Control（Ctrl）+ マウスホイール**でシート全体を拡大・縮小します。
- 通常のホイール操作は変更しません。
- ウィンドウを表示せず、メニューバーに常駐します。
- メニューバーのメニューから終了できます。

### 動作環境

- **macOS 13 Ventura以降を対象**としています。プロジェクトのDeployment Targetも確認してください。
- Apple Numbersが必要です。
- 開発・動作確認は限られた環境で行っています。Apple Silicon Mac、ほかのmacOS/Numbersバージョンでの動作は未確認です。
- ソースコードから実行する場合は、対応するXcodeが必要です。

### ソースコードから実行する

1. このリポジトリをダウンロードまたはcloneします。
2. `WheelZoom.xcodeproj`をXcodeで開きます。
3. 必要に応じて `Signing & Capabilities` で自分の開発用Teamを設定します。
4. `My Mac`を実行先として選択し、**⌘ + R**で実行します。
5. 「システム設定 → プライバシーとセキュリティ → アクセシビリティ」でWheelZoomの操作を許可します。
6. Numbersを前面にしてCtrl + ホイールを操作します。

**権限トラブル:** 許可がONでも動作せず、デバッグログで`Accessibility trusted: false`と表示される場合は、WheelZoomを終了し、アクセシビリティの一覧から古いWheelZoomを削除して、再起動後に再登録してください。これは開発中の再ビルドによって署名が変化した場合などに起こることがあります。

### プライバシー

現在の実装はスクロールイベント、Controlキーの状態、前面アプリをローカルで判定し、Numbersに拡大・縮小のキー操作を送信します。ネットワーク送信機能は実装していません。開発用ビルドではデバッグログが表示される場合があります。

### ライセンス

MIT License。詳細は[`LICENSE`](LICENSE)を参照してください。

## English

WheelZoom is a lightweight macOS menu-bar utility that lets users zoom the entire Apple Numbers sheet with **Control + mouse wheel**, using an ordinary scroll-wheel mouse.

### Features

- Control + scroll to zoom in or out while Numbers is frontmost.
- Ordinary scrolling remains unchanged.
- Runs in the menu bar without a regular window.
- Quit from the menu-bar menu.

### Requirements and compatibility

- **Targets macOS 13 Ventura or later** (verify the project's Deployment Target).
- Apple Numbers is required.
- Testing is limited. Apple Silicon Macs and additional macOS/Numbers versions have **not yet been verified**.
- An appropriate version of Xcode is required to build from source.

### Build and run

1. Clone or download this repository.
2. Open `WheelZoom.xcodeproj` in Xcode.
3. Configure your own development Team under `Signing & Capabilities` if needed.
4. Select `My Mac` and press **⌘ + R**.
5. Allow WheelZoom under **System Settings → Privacy & Security → Accessibility**.
6. Bring Numbers to the foreground and use Control + mouse wheel.

**Permission troubleshooting:** If permission appears enabled but the debug console shows `Accessibility trusted: false`, quit WheelZoom, remove its old Accessibility entry, restart it, and grant permission again. A changed development signature after rebuilding can require a new permission entry.

### Privacy

The current source checks scroll events, the Control modifier, and the frontmost application locally. It sends zoom keyboard shortcuts to Numbers. No network transmission is implemented. Development builds may produce diagnostic logs.

### License

MIT License. See [`LICENSE`](LICENSE).
