import SwiftUI

struct TranslationResultView: View {
    let originalText: String
    let translatedText: String
    let sourceLanguage: String
    let targetLanguage: String
    let onClose: () -> Void

    @State private var showCopiedFeedback = false

    var body: some View {
        ZStack {
            VisualEffectView(material: .hudWindow, blendingMode: .behindWindow)

            VStack(spacing: 0) {
                contentArea
                languageBar
            }
            .padding(20)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
    }

    private var contentArea: some View {
        VStack(alignment: .leading, spacing: 16) {
            textSection(
                label: sourceLanguage,
                text: originalText,
                isOriginal: true
            )

            Divider()
                .background(Color.primary.opacity(0.1))

            textSection(
                label: targetLanguage,
                text: translatedText,
                isOriginal: false
            )
        }
    }

    private func textSection(label: String, text: String, isOriginal: Bool) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.secondary)
                .textCase(.uppercase)

            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.primary)
                .textSelection(.enabled)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .onTapGesture {
            if !isOriginal {
                copyToClipboard(text)
            }
        }
    }

    private var languageBar: some View {
        HStack(spacing: 12) {
            Spacer()

            if showCopiedFeedback {
                Text("已复制")
                    .font(.system(size: 11))
                    .foregroundColor(.green)
                    .transition(.opacity)
            }

            Button(action: onClose) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 12)
    }

    private func copyToClipboard(_ text: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)

        withAnimation {
            showCopiedFeedback = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showCopiedFeedback = false
            }
        }
    }
}

struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}
