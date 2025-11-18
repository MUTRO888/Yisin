import Foundation

class TranslationEngine {
    static let shared = TranslationEngine()

    private let geminiService = GeminiService.shared
    private let languageDetector = LanguageDetector.shared

    private init() {}

    func translate(text: String) async -> TranslationResult {
        let settings = SettingsManager.shared

        guard !settings.apiKey.isEmpty else {
            return .failure("未配置 API Key\n\n请在设置中添加您的 Gemini API Key")
        }

        let detectedLanguage = languageDetector.detectLanguage(text)
        let systemPrompt = buildPrompt(for: detectedLanguage, basePrompt: settings.systemPrompt)

        do {
            let translation = try await geminiService.translate(
                text: text,
                systemPrompt: systemPrompt,
                apiKey: settings.apiKey
            )

            return .success(
                original: text,
                translated: translation,
                sourceLanguage: detectedLanguage,
                targetLanguage: detectedLanguage == .chinese ? .english : .chinese
            )
        } catch let error as GeminiError {
            return .failure(error.errorDescription ?? "翻译失败")
        } catch {
            return .failure("网络错误: \(error.localizedDescription)")
        }
    }

    private func buildPrompt(for language: DetectedLanguage, basePrompt: String) -> String {
        let direction: String
        switch language {
        case .chinese:
            direction = "将以下中文翻译成英文"
        case .english:
            direction = "将以下英文翻译成简体中文"
        case .other:
            direction = "智能检测语言并翻译（中文↔英文）"
        }

        return """
        \(direction)

        要求：
        - 保持原文的语气和风格
        - 对于专业术语，必要时在括号中保留原文
        - 只返回翻译结果，不要解释

        原文：
        \(basePrompt)
        """
    }
}

enum TranslationResult {
    case success(original: String, translated: String, sourceLanguage: DetectedLanguage, targetLanguage: DetectedLanguage)
    case failure(String)

    var translatedText: String {
        switch self {
        case .success(_, let translated, _, _):
            return translated
        case .failure(let error):
            return error
        }
    }

    var isSuccess: Bool {
        if case .success = self {
            return true
        }
        return false
    }
}
