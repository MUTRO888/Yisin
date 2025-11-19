import AppKit

class HotkeyManager {
    static let shared = HotkeyManager()

    private var eventMonitor: Any?
    private var targetKeyCode: UInt32?
    private var targetModifiers: UInt32?

    var onHotkeyPressed: (() -> Void)?

    private init() {}

    func registerHotkey(keyCode: UInt32, modifiers: UInt32) -> Bool {
        unregisterHotkey()

        self.targetKeyCode = keyCode
        self.targetModifiers = modifiers

        // 使用全局事件监听器（不仅限于本应用）
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            guard let self = self,
                  let targetKeyCode = self.targetKeyCode,
                  let targetModifiers = self.targetModifiers else {
                return
            }

            if event.keyCode == targetKeyCode {
                let eventModifiers = event.modifierFlags.intersection(.deviceIndependentFlagsMask).rawValue

                // 检查修饰键是否匹配
                if eventModifiers == UInt(targetModifiers) {
                    DispatchQueue.main.async {
                        self.onHotkeyPressed?()
                    }
                }
            }
        }

        return true
    }

    func unregisterHotkey() {
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
            eventMonitor = nil
        }
        targetKeyCode = nil
        targetModifiers = nil
    }

    func parseHotkeyString(_ hotkeyString: String) -> (keyCode: UInt32, modifiers: UInt32)? {
        let components = hotkeyString.components(separatedBy: " ")
        guard let lastComponent = components.last else { return nil }

        var modifiers: UInt32 = 0

        for component in components.dropLast() {
            switch component {
            case "⌘":
                modifiers |= UInt32(NSEvent.ModifierFlags.command.rawValue)
            case "⇧":
                modifiers |= UInt32(NSEvent.ModifierFlags.shift.rawValue)
            case "⌥":
                modifiers |= UInt32(NSEvent.ModifierFlags.option.rawValue)
            case "⌃":
                modifiers |= UInt32(NSEvent.ModifierFlags.control.rawValue)
            default:
                break
            }
        }

        guard let keyCode = keyCodeForCharacter(lastComponent) else {
            return nil
        }

        return (keyCode, modifiers)
    }

    private func keyCodeForCharacter(_ character: String) -> UInt32? {
        let keyMap: [String: UInt32] = [
            "A": 0x00, "B": 0x0B, "C": 0x08, "D": 0x02, "E": 0x0E,
            "F": 0x03, "G": 0x05, "H": 0x04, "I": 0x22, "J": 0x26,
            "K": 0x28, "L": 0x25, "M": 0x2E, "N": 0x2D, "O": 0x1F,
            "P": 0x23, "Q": 0x0C, "R": 0x0F, "S": 0x01, "T": 0x11,
            "U": 0x20, "V": 0x09, "W": 0x0D, "X": 0x07, "Y": 0x10,
            "Z": 0x06,
            "0": 0x1D, "1": 0x12, "2": 0x13, "3": 0x14, "4": 0x15,
            "5": 0x17, "6": 0x16, "7": 0x1A, "8": 0x1C, "9": 0x19,
            "Space": 0x31, "Return": 0x24, "Escape": 0x35
        ]

        return keyMap[character.uppercased()]
    }
}
