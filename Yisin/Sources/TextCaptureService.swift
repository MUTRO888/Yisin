import AppKit
import ApplicationServices

class TextCaptureService {
    static let shared = TextCaptureService()

    private init() {}

    func captureSelectedText() -> String? {
        let systemWideElement = AXUIElementCreateSystemWide()

        var focusedElement: CFTypeRef?
        let focusedResult = AXUIElementCopyAttributeValue(
            systemWideElement,
            kAXFocusedUIElementAttribute as CFString,
            &focusedElement
        )

        guard focusedResult == .success,
              let element = focusedElement else {
            return fallbackToPasteboard()
        }

        var selectedText: CFTypeRef?
        let selectedResult = AXUIElementCopyAttributeValue(
            element as! AXUIElement,
            kAXSelectedTextAttribute as CFString,
            &selectedText
        )

        if selectedResult == .success,
           let text = selectedText as? String,
           !text.isEmpty {
            return text
        }

        return fallbackToPasteboard()
    }

    private func fallbackToPasteboard() -> String? {
        let pasteboard = NSPasteboard.general
        let previousContents = pasteboard.string(forType: .string)

        pasteboard.clearContents()

        let source = CGEventSource(stateID: .hidSystemState)

        let keyDownEvent = CGEvent(keyboardEventSource: source, virtualKey: 0x08, keyDown: true)
        keyDownEvent?.flags = .maskCommand

        let keyUpEvent = CGEvent(keyboardEventSource: source, virtualKey: 0x08, keyDown: false)
        keyUpEvent?.flags = .maskCommand

        keyDownEvent?.post(tap: .cghidEventTap)
        keyUpEvent?.post(tap: .cghidEventTap)

        Thread.sleep(forTimeInterval: 0.1)

        let copiedText = pasteboard.string(forType: .string)

        if let previousContents = previousContents {
            pasteboard.clearContents()
            pasteboard.setString(previousContents, forType: .string)
        }

        return copiedText
    }

    func checkAccessibilityPermission() -> Bool {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: false]
        return AXIsProcessTrustedWithOptions(options)
    }
}
