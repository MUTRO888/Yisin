import Foundation
import NaturalLanguage

class LanguageDetector {
    static let shared = LanguageDetector()

    private init() {}

    func detectLanguage(_ text: String) -> DetectedLanguage {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(text)

        guard let dominantLanguage = recognizer.dominantLanguage else {
            return .other
        }

        switch dominantLanguage {
        case .simplifiedChinese, .traditionalChinese:
            return .chinese
        case .english:
            return .english
        default:
            return .other
        }
    }

    func getLanguageLabel(_ language: DetectedLanguage) -> String {
        switch language {
        case .chinese:
            return "中文"
        case .english:
            return "EN"
        case .other:
            return "其他"
        }
    }
}

enum DetectedLanguage {
    case chinese
    case english
    case other
}
