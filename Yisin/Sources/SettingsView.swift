import SwiftUI

struct SettingsView: View {
    @StateObject private var settings = SettingsManager.shared
    @State private var isRecordingHotkey = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                headerSection
                apiSection
                hotkeySection
                promptSection
                historySection
            }
            .padding(32)
        }
        .frame(minWidth: 500, minHeight: 600)
        .background(Color(nsColor: .windowBackgroundColor))
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            YisinLogoShape()
                .stroke(Color.primary, lineWidth: 1.5)
                .frame(width: 48, height: 48)

            Text("Yisin")
                .font(.system(size: 28, weight: .light, design: .default))

            Text("背景化的翻译伴侣")
                .font(.system(size: 13))
                .foregroundColor(.secondary)
        }
    }

    private var apiSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("API 配置")

            VStack(alignment: .leading, spacing: 8) {
                Text("Gemini API Key")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)

                SecureField("输入您的 API Key", text: $settings.apiKey)
                    .textFieldStyle(.plain)
                    .padding(10)
                    .background(Color(nsColor: .controlBackgroundColor))
                    .cornerRadius(6)
            }

            Text("API Key 将安全地存储在 macOS Keychain 中")
                .font(.system(size: 11))
                .foregroundColor(.secondary)
        }
    }

    private var hotkeySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("快捷键")

            HotkeyRecorderView(hotkeyString: $settings.hotkeyDisplay)

            Text("在任意应用中选中文本后按此快捷键进行翻译")
                .font(.system(size: 11))
                .foregroundColor(.secondary)
        }
    }

    private var promptSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("提示词")

            TextEditor(text: $settings.systemPrompt)
                .font(.system(size: 12, design: .monospaced))
                .frame(height: 120)
                .padding(4)
                .background(Color(nsColor: .controlBackgroundColor))
                .cornerRadius(6)

            HStack {
                Button("使用默认模板") {
                    settings.systemPrompt = SettingsManager.defaultPrompt
                }
                .buttonStyle(.plain)
                .foregroundColor(.blue)
                .font(.system(size: 11))

                Spacer()
            }
        }
    }

    private var historySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                sectionTitle("历史记录")
                Spacer()
                Button("清除") {
                    settings.clearHistory()
                }
                .buttonStyle(.plain)
                .foregroundColor(.red)
                .font(.system(size: 11))
            }

            Toggle("保存翻译历史", isOn: $settings.saveHistory)
                .toggleStyle(.switch)
        }
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 15, weight: .medium))
            .foregroundColor(.primary)
    }
}
