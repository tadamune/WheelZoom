//
//  WheelZoomApp.swift
//  WheelZoom
//
//  Created by T.Nakai on 2026/10/31.
//

import SwiftUI
import AppKit
import ApplicationServices

@main
struct WheelZoomApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate

    var body: some Scene {

        MenuBarExtra(
            "WheelZoom",
            systemImage: "plus.magnifyingglass"
        ) {
            WheelZoomMenu()
        }
    }
}

// メニューバーの表示内容
struct WheelZoomMenu: View {

    @State private var trusted = AXIsProcessTrusted()

    var body: some View {

        if trusted {
            Label(
                "アクセシビリティ：許可済み",
                systemImage: "checkmark.shield"
            )
        } else {
            Label(
                "アクセシビリティ：未許可",
                systemImage: "exclamationmark.triangle"
            )

            Button("アクセシビリティの許可を要求") {
                requestPermission()
            }
        }

        Divider()

        Button("アクセシビリティ設定を開く") {
            openAccessibilitySettings()
        }

        Button("権限状態を再確認") {
            refreshPermission()
        }

        Divider()

        Text("Numbers：Ctrl + ホイールで倍率変更")

        Divider()

        Button("WheelZoomを終了") {
            NSApplication.shared.terminate(nil)
        }
    }

    // 現在の権限状態を取得
    private func refreshPermission() {
        trusted = AXIsProcessTrusted()
    }

    // macOSに許可案内を要求
    private func requestPermission() {

        let options = [
            kAXTrustedCheckOptionPrompt.takeUnretainedValue()
                as String: true
        ] as CFDictionary

        _ = AXIsProcessTrustedWithOptions(options)

        refreshPermission()
    }

    // システム設定のアクセシビリティ権限画面を開く
    private func openAccessibilitySettings() {

        let address =
            "x-apple.systempreferences:" +
            "com.apple.preference.security?Privacy_Accessibility"

        if let url = URL(string: address) {
            NSWorkspace.shared.open(url)
        }
    }
}

// アプリの起動と終了を管理
final class AppDelegate: NSObject, NSApplicationDelegate {

    private let wheelMonitor = WheelZoomMonitor()

    func applicationDidFinishLaunching(
        _ notification: Notification
    ) {

        wheelMonitor.start()

        // 未許可の場合だけ案内を要求する
        if !AXIsProcessTrusted() {

            let options = [
                kAXTrustedCheckOptionPrompt.takeUnretainedValue()
                    as String: true
            ] as CFDictionary

            _ = AXIsProcessTrustedWithOptions(options)
        }
    }

    func applicationWillTerminate(
        _ notification: Notification
    ) {
        wheelMonitor.stop()
    }
}
