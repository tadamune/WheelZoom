//
//  WheelZoomApp.swift
//  WheelZoom
//
//  Created by T.Nakai on 2026/10/31.
//


import SwiftUI
import AppKit

@main
struct WheelZoomApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate

    var body: some Scene {

        MenuBarExtra(
            "WheelZoom",
            systemImage: "plus.magnifyingglass"
        ) {

            Text("Numbers：Ctrl + ホイールで倍率変更")

            Divider()

            Button("WheelZoomを終了") {
                NSApplication.shared.terminate(nil)
            }
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
    }

    func applicationWillTerminate(
        _ notification: Notification
    ) {
        wheelMonitor.stop()
    }
}
