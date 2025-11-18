import Foundation
import Security

class SettingsManager: ObservableObject {
    static let shared = SettingsManager()

    private let keychainService = "com.yisin.app"
    private let apiKeyAccount = "gemini-api-key"

    @Published var apiKey: String {
        didSet {
            saveAPIKeyToKeychain(apiKey)
        }
    }

    @Published var hotkeyDisplay: String {
        didSet {
            UserDefaults.standard.set(hotkeyDisplay, forKey: "hotkeyDisplay")
            NotificationCenter.default.post(name: NSNotification.Name("HotkeyChanged"), object: nil)
        }
    }

    @Published var systemPrompt: String {
        didSet {
            UserDefaults.standard.set(systemPrompt, forKey: "systemPrompt")
        }
    }

    @Published var saveHistory: Bool {
        didSet {
            UserDefaults.standard.set(saveHistory, forKey: "saveHistory")
        }
    }

    static let defaultPrompt = """
You are a professional translator. Translate the following text naturally and accurately.

Rules:
- If the text is in English, translate to Simplified Chinese
- If the text is in Chinese, translate to English
- Maintain the original tone and style
- For technical terms, provide the original term in parentheses if necessary
- Only return the translation, no explanations

Text to translate:
"""

    private init() {
        self.apiKey = ""
        self.hotkeyDisplay = UserDefaults.standard.string(forKey: "hotkeyDisplay") ?? "⌘⇧T"
        self.systemPrompt = UserDefaults.standard.string(forKey: "systemPrompt") ?? Self.defaultPrompt
        self.saveHistory = UserDefaults.standard.bool(forKey: "saveHistory")

        self.apiKey = loadAPIKeyFromKeychain() ?? ""
    }

    private func saveAPIKeyToKeychain(_ key: String) {
        let data = key.data(using: .utf8)!

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: apiKeyAccount,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    private func loadAPIKeyFromKeychain() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: apiKeyAccount,
            kSecReturnData as String: true
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess,
              let data = result as? Data,
              let key = String(data: data, encoding: .utf8) else {
            return nil
        }

        return key
    }

    func clearHistory() {
        UserDefaults.standard.removeObject(forKey: "translationHistory")
    }
}
