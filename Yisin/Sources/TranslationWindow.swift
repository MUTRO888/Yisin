import AppKit
import SwiftUI

class TranslationWindow: NSWindow {
    private var translationViewController: NSHostingController<TranslationResultView>?

    init() {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 200),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )

        self.level = .floating
        self.isOpaque = false
        self.backgroundColor = .clear
        self.hasShadow = true
        self.isMovableByWindowBackground = false
        self.collectionBehavior = [.canJoinAllSpaces, .stationary]

        setupView()
    }

    private func setupView() {
        let resultView = TranslationResultView(
            originalText: "",
            translatedText: "",
            sourceLanguage: "EN",
            targetLanguage: "中文",
            onClose: { [weak self] in
                self?.fadeOut()
            }
        )

        translationViewController = NSHostingController(rootView: resultView)
        self.contentView = translationViewController?.view
    }

    func show(originalText: String, translatedText: String = "翻译中...", sourceLanguage: String = "EN", targetLanguage: String = "中文") {
        updateContent(originalText: originalText, translatedText: translatedText, sourceLanguage: sourceLanguage, targetLanguage: targetLanguage)
        positionNearMouse()
        fadeIn()
    }

    func updateContent(originalText: String, translatedText: String, sourceLanguage: String = "EN", targetLanguage: String = "中文") {
        let resultView = TranslationResultView(
            originalText: originalText,
            translatedText: translatedText,
            sourceLanguage: sourceLanguage,
            targetLanguage: targetLanguage,
            onClose: { [weak self] in
                self?.fadeOut()
            }
        )

        translationViewController = NSHostingController(rootView: resultView)
        self.contentView = translationViewController?.view

        adjustSize(for: originalText, and: translatedText)
    }

    private func adjustSize(for originalText: String, and translatedText: String) {
        let maxWidth: CGFloat = 500
        let minWidth: CGFloat = 300

        let estimatedHeight = estimateHeight(for: originalText, and: translatedText)
        let width = min(maxWidth, max(minWidth, CGFloat(max(originalText.count, translatedText.count)) * 8))

        let newSize = NSSize(width: width, height: estimatedHeight)

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.2
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            self.animator().setFrame(
                NSRect(origin: self.frame.origin, size: newSize),
                display: true
            )
        }
    }

    private func estimateHeight(for originalText: String, and translatedText: String) -> CGFloat {
        let baseHeight: CGFloat = 120
        let lineHeight: CGFloat = 20

        let originalLines = max(1, originalText.count / 50)
        let translatedLines = max(1, translatedText.count / 50)

        return baseHeight + CGFloat(originalLines + translatedLines) * lineHeight
    }

    private func positionNearMouse() {
        guard let screen = NSScreen.main else { return }

        let mouseLocation = NSEvent.mouseLocation
        let windowSize = self.frame.size

        var x = mouseLocation.x + 20
        var y = mouseLocation.y - windowSize.height - 20

        if x + windowSize.width > screen.frame.maxX {
            x = mouseLocation.x - windowSize.width - 20
        }

        if y < screen.frame.minY {
            y = mouseLocation.y + 20
        }

        self.setFrameOrigin(NSPoint(x: x, y: y))
    }

    func fadeIn() {
        self.alphaValue = 0
        self.makeKeyAndOrderFront(nil)

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)
            self.animator().alphaValue = 1.0
        }
    }

    func fadeOut() {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.2
            context.timingFunction = CAMediaTimingFunction(name: .easeIn)
            self.animator().alphaValue = 0
        }, completionHandler: {
            self.orderOut(nil)
        })
    }

    override var canBecomeKey: Bool {
        return true
    }

    override func cancelOperation(_ sender: Any?) {
        fadeOut()
    }
}
