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
    private var translationWindow: TranslationWindow?
    private var inputWindow: TranslationInputWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        setupMenuBar()
        setupHotkey()
        setupWindows()
    }

    private func setupWindows() {
        translationWindow = TranslationWindow()
        inputWindow = TranslationInputWindow(onTranslate: { [weak self] text in
            self?.translateText(text)
        })
    }

    private func setupMenuBar() {
        menuBarController = MenuBarController()
        statusItem = menuBarController?.statusItem
    }

    private func setupHotkey() {
        let settings = SettingsManager.shared

        print("🔧 尝试注册快捷键: \(settings.hotkeyDisplay)")

        if let (keyCode, modifiers) = hotkeyManager.parseHotkeyString(settings.hotkeyDisplay) {
            print("🔑 解析成功 - KeyCode: \(keyCode), Modifiers: \(modifiers)")
            let success = hotkeyManager.registerHotkey(keyCode: keyCode, modifiers: modifiers)
            if success {
                print("✅ 快捷键注册成功: \(settings.hotkeyDisplay)")
            } else {
                print("❌ 快捷键注册失败")
            }
        } else {
            print("❌ 快捷键解析失败: \(settings.hotkeyDisplay)")
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
        print("🎯 快捷键被按下，显示输入窗口")
        inputWindow?.showAndFocus()
    }

    private func translateText(_ text: String) {
        menuBarController?.updateIconState(.thinking)

        let detector = LanguageDetector.shared
        let detectedLang = detector.detectLanguage(text)
        let sourceLang = detector.getLanguageLabel(detectedLang)
        let targetLang = detectedLang == .chinese ? "EN" : "中文"

        translationWindow?.show(
            originalText: text,
            translatedText: "翻译中...",
            sourceLanguage: sourceLang,
            targetLanguage: targetLang
        )

        print("📝 翻译文本: \(text)")
        print("🌐 检测语言: \(sourceLang) → \(targetLang)")

        Task {
            let result = await TranslationEngine.shared.translate(text: text)

            await MainActor.run {
                switch result {
                case .success(let original, let translated, let source, let target):
                    let sourceLangLabel = detector.getLanguageLabel(source)
                    let targetLangLabel = detector.getLanguageLabel(target)

                    self.translationWindow?.updateContent(
                        originalText: original,
                        translatedText: translated,
                        sourceLanguage: sourceLangLabel,
                        targetLanguage: targetLangLabel
                    )

                    self.menuBarController?.updateIconState(.completed)
                    print("✅ 翻译成功")

                case .failure(let error):
                    self.translationWindow?.updateContent(
                        originalText: text,
                        translatedText: "❌ \(error)",
                        sourceLanguage: sourceLang,
                        targetLanguage: targetLang
                    )

                    self.menuBarController?.updateIconState(.idle)
                    print("❌ 翻译失败: \(error)")
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.menuBarController?.updateIconState(.idle)
                }
            }
        }
    }

}
