import AppKit
import Carbon

class HotkeyManager {
    static let shared = HotkeyManager()

    private var eventHandler: EventHandlerRef?
    private var hotKeyRef: EventHotKeyRef?
    private var hotKeyID = EventHotKeyID(signature: OSType(0x59534E), id: 1)

    var onHotkeyPressed: (() -> Void)?

    private init() {}

    func registerHotkey(keyCode: UInt32, modifiers: UInt32) -> Bool {
        unregisterHotkey()

        var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))

        let status = InstallEventHandler(
            GetApplicationEventTarget(),
            { (nextHandler, event, userData) -> OSStatus in
                guard let manager = userData?.assumingMemoryBound(to: HotkeyManager.self).pointee else {
                    return OSStatus(eventNotHandledErr)
                }

                var hotKeyID = EventHotKeyID()
                GetEventParameter(
                    event,
                    EventParamName(kEventParamDirectObject),
                    EventParamType(typeEventHotKeyID),
                    nil,
                    MemoryLayout<EventHotKeyID>.size,
                    nil,
                    &hotKeyID
                )

                if hotKeyID.id == manager.hotKeyID.id {
                    DispatchQueue.main.async {
                        manager.onHotkeyPressed?()
                    }
                    return noErr
                }

                return OSStatus(eventNotHandledErr)
            },
            1,
            &eventType,
            Unmanaged.passUnretained(self).toOpaque(),
            &eventHandler
        )

        guard status == noErr else {
            return false
        }

        var hotKeyRef: EventHotKeyRef?
        let registerStatus = RegisterEventHotKey(
            keyCode,
            modifiers,
            hotKeyID,
            GetApplicationEventTarget(),
            0,
            &hotKeyRef
        )

        guard registerStatus == noErr else {
            return false
        }

        self.hotKeyRef = hotKeyRef
        return true
    }

    func unregisterHotkey() {
        if let hotKeyRef = hotKeyRef {
            UnregisterEventHotKey(hotKeyRef)
            self.hotKeyRef = nil
        }

        if let eventHandler = eventHandler {
            RemoveEventHandler(eventHandler)
            self.eventHandler = nil
        }
    }

    func parseHotkeyString(_ hotkeyString: String) -> (keyCode: UInt32, modifiers: UInt32)? {
        let components = hotkeyString.components(separatedBy: " ")
        guard let lastComponent = components.last else { return nil }

        var modifiers: UInt32 = 0

        for component in components.dropLast() {
            switch component {
            case "⌘":
                modifiers |= UInt32(cmdKey)
            case "⇧":
                modifiers |= UInt32(shiftKey)
            case "⌥":
                modifiers |= UInt32(optionKey)
            case "⌃":
                modifiers |= UInt32(controlKey)
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
