//
//  WheelZoomMonitor.swift
//  WheelZoom
//
//  Created by T.Nakai on 2026/11/01.
//


import AppKit
import CoreGraphics
import ApplicationServices


final class WheelZoomMonitor {
    
    private var monitor: Any?
    private var lastZoomTime = Date.distantPast
    
    // 監視を開始する
    func start() {
        
        
        
        guard monitor == nil else { return }
        
        monitor = NSEvent.addGlobalMonitorForEvents(
            matching: .scrollWheel
        ) { [weak self] event in
            
            // 監視オブジェクトの存在確認
            guard let self else {
                print("エラー：WheelZoomMonitorが解放されています")
                return
            }
            
            let appID = NSWorkspace.shared.frontmostApplication?
                .bundleIdentifier ?? "不明"
            
            let ctrl = event.modifierFlags.contains(.control)
            let delta = event.scrollingDeltaY
            
            print("App: \(appID)")
            print("Ctrl: \(ctrl)")
            print("Delta: \(delta)")
            
            // Numbersだけを対象にする
            guard appID == "com.apple.iWork.Numbers"
            else { return }
            
            // Ctrlキーの確認
            guard ctrl else { return }
            
            // ホイール回転量の確認
            guard delta != 0 else { return }
            
            print("Numbers操作：条件判定通過")
            
            // 連続イベントの間引き
            let now = Date()
            
            guard now.timeIntervalSince(
                self.lastZoomTime
            ) >= 0.18 else {
                print("連続イベントを間引きました")
                return
            }
            
            self.lastZoomTime = now
            
            print("sendZoomShortcutを呼び出します")
            
            self.sendZoomShortcut(zoomIn: delta > 0)
        }
        
        print("WheelZoom：監視開始")
    }
    
    
    
    
    // Numbersへショートカットを送信
    private func sendZoomShortcut(zoomIn: Bool) {
        print("倍率変更指示: \(zoomIn ? "拡大" : "縮小")")
        print("Accessibility trusted: \(AXIsProcessTrusted())")
        
        // 拡大：ピリオド、縮小：カンマ
        let keyCode: CGKeyCode = zoomIn ? 47 : 43
        
        let flags: CGEventFlags = [
            .maskCommand,
            .maskShift
        ]
        
        guard let keyDown = CGEvent(
            keyboardEventSource: nil,
            virtualKey: keyCode,
            keyDown: true
        ),
              let keyUp = CGEvent(
                keyboardEventSource: nil,
                virtualKey: keyCode,
                keyDown: false
              ) else { return }
        
        keyDown.flags = flags
        keyUp.flags = flags
        
        keyDown.post(tap: .cghidEventTap)
        keyUp.post(tap: .cghidEventTap)
    }
    
    // 監視を停止する
    func stop() {
        
        if let monitor {
            NSEvent.removeMonitor(monitor)
            self.monitor = nil
        }
        
        print("WheelZoom：監視終了")
    }
}
