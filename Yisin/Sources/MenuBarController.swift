import AppKit
import SwiftUI

class MenuBarController: NSObject {
    var statusItem: NSStatusItem
    private var iconView: MenuBarIconView?
    private var settingsWindow: NSWindow?

    override init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        super.init()

        setupStatusItem()
        setupMenu()
    }

    private func setupStatusItem() {
        if let button = statusItem.button {
            let hostingView = NSHostingView(rootView: MenuBarIconView(state: .idle))
            hostingView.frame = NSRect(x: 0, y: 0, width: 22, height: 22)
            button.addSubview(hostingView)
            button.action = #selector(statusItemClicked)
            button.target = self
        }
    }

    private func setupMenu() {
        let menu = NSMenu()

        menu.addItem(NSMenuItem(title: "设置", action: #selector(openSettings), keyEquivalent: ","))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "退出 Yisin", action: #selector(quit), keyEquivalent: "q"))

        statusItem.menu = menu
    }

    @objc private func statusItemClicked() {
        openSettings()
    }

    @objc private func openSettings() {
        if settingsWindow == nil {
            let settingsView = SettingsView()
            let hostingController = NSHostingController(rootView: settingsView)

            let window = NSWindow(contentViewController: hostingController)
            window.title = "Yisin 设置"
            window.styleMask = [.titled, .closable, .miniaturizable]
            window.setContentSize(NSSize(width: 500, height: 600))
            window.center()

            settingsWindow = window
        }

        settingsWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc private func quit() {
        NSApplication.shared.terminate(nil)
    }

    func updateIconState(_ state: MenuBarIconState) {
        if let button = statusItem.button {
            button.subviews.forEach { $0.removeFromSuperview() }
            let hostingView = NSHostingView(rootView: MenuBarIconView(state: state))
            hostingView.frame = NSRect(x: 0, y: 0, width: 22, height: 22)
            button.addSubview(hostingView)
        }
    }
}

enum MenuBarIconState {
    case idle
    case listening
    case thinking
    case completed
}
