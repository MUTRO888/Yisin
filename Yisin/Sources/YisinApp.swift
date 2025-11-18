import SwiftUI

@main
struct YisinApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private var menuBarController: MenuBarController?
    private let hotkeyManager = HotkeyManager.shared
    private let textCapture = TextCaptureService.shared

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        setupMenuBar()
        setupHotkey()
        checkAccessibilityPermissions()
    }

    private func setupMenuBar() {
        menuBarController = MenuBarController()
        statusItem = menuBarController?.statusItem
    }

    private func setupHotkey() {
        let settings = SettingsManager.shared

        if let (keyCode, modifiers) = hotkeyManager.parseHotkeyString(settings.hotkeyDisplay) {
            let success = hotkeyManager.registerHotkey(keyCode: keyCode, modifiers: modifiers)
            if success {
                print("✅ 快捷键注册成功: \(settings.hotkeyDisplay)")
            } else {
                print("❌ 快捷键注册失败")
            }
        }

        hotkeyManager.onHotkeyPressed = { [weak self] in
            self?.handleHotkeyPressed()
        }

        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("HotkeyChanged"),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.setupHotkey()
        }
    }

    private func handleHotkeyPressed() {
        menuBarController?.updateIconState(.listening)

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let text = self?.textCapture.captureSelectedText(), !text.isEmpty else {
                DispatchQueue.main.async {
                    self?.menuBarController?.updateIconState(.idle)
                    self?.showNoTextAlert()
                }
                return
            }

            DispatchQueue.main.async {
                self?.menuBarController?.updateIconState(.thinking)
                print("📝 捕获的文本: \(text)")

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self?.menuBarController?.updateIconState(.completed)

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self?.menuBarController?.updateIconState(.idle)
                    }
                }
            }
        }
    }

    private func showNoTextAlert() {
        let alert = NSAlert()
        alert.messageText = "未检测到选中文本"
        alert.informativeText = "请先选中要翻译的文本，然后按快捷键。"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "好的")
        alert.runModal()
    }

    private func checkAccessibilityPermissions() {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options)

        if !accessEnabled {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.showPermissionAlert()
            }
        }
    }

    private func showPermissionAlert() {
        let alert = NSAlert()
        alert.messageText = "辅助功能权限"
        alert.informativeText = "Yisin 需要辅助功能权限来捕获选中的文本。\n\n请在系统设置中授予权限。"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "打开系统设置")
        alert.addButton(withTitle: "稍后")

        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!)
        }
    }
}
