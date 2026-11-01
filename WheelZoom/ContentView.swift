
import SwiftUI
import AppKit
import CoreGraphics
import ApplicationServices

struct ContentView: View {

    @State private var status = "操作を待っています"
    @State private var monitor: Any?
    @State private var lastZoomTime = Date.distantPast

    var body: some View {
        VStack(spacing: 20) {
            Text("WheelZoom")
                .font(.title)

            Text(status)

            Text("Numbersで Ctrl + ホイールを操作")
                .font(.caption)
        }
        .frame(width: 420, height: 240)
        .onAppear {
            if !AXIsProcessTrusted() {
                status = "アクセシビリティの許可が必要です"
            }
            startMonitoring()
        }
        .onDisappear {
            stopMonitoring()
        }
    }

    func startMonitoring() {
        guard monitor == nil else { return }

        monitor = NSEvent.addGlobalMonitorForEvents(
            matching: .scrollWheel
        ) { event in

            // Numbersだけを対象にする
            guard NSWorkspace.shared.frontmostApplication?
                .bundleIdentifier == "com.apple.iWork.Numbers"
            else { return }

            // Ctrlキーが押されているか
            guard event.modifierFlags.contains(.control)
            else { return }

            let delta = event.scrollingDeltaY
            guard delta != 0 else { return }

            DispatchQueue.main.async {
                // 連続イベントを間引く
                let now = Date()
                guard now.timeIntervalSince(lastZoomTime) >= 0.18
                else { return }

                lastZoomTime = now

                let zoomIn = delta > 0
                sendZoomShortcut(zoomIn: zoomIn)

                status = zoomIn
                    ? "Numbers：拡大指示"
                    : "Numbers：縮小指示"

                print(status)
            }
        }
    }

    func sendZoomShortcut(zoomIn: Bool) {

        // 47 = ピリオド、43 = カンマ
        let keyCode: CGKeyCode = zoomIn ? 47 : 43

        // Command + Shift
        let flags: CGEventFlags = [.maskCommand, .maskShift]

        guard let keyDown = CGEvent(
            keyboardEventSource: nil,
            virtualKey: keyCode,
            keyDown: true
        ), let keyUp = CGEvent(
            keyboardEventSource: nil,
            virtualKey: keyCode,
            keyDown: false
        ) else { return }

        keyDown.flags = flags
        keyUp.flags = flags

        keyDown.post(tap: .cghidEventTap)
        keyUp.post(tap: .cghidEventTap)
    }

    func stopMonitoring() {
        if let monitor {
            NSEvent.removeMonitor(monitor)
            self.monitor = nil
        }
    }
}
