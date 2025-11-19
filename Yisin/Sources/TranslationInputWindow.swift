import AppKit
import SwiftUI

class TranslationInputWindow: NSWindow {
    private var inputViewController: NSHostingController<TranslationInputView>?
    private var onTranslate: ((String) -> Void)?

    init(onTranslate: @escaping (String) -> Void) {
        self.onTranslate = onTranslate

        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 200),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )

        self.title = "Yisin"
        self.titlebarAppearsTransparent = true
        self.isMovableByWindowBackground = true
        self.level = .floating
        self.center()

        setupView()
    }

    private func setupView() {
        let inputView = TranslationInputView(
            onTranslate: { [weak self] text in
                self?.onTranslate?(text)
                self?.close()
            },
            onCancel: { [weak self] in
                self?.close()
            }
        )

        inputViewController = NSHostingController(rootView: inputView)
        self.contentView = inputViewController?.view
    }

    func showAndFocus() {
        self.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    override func cancelOperation(_ sender: Any?) {
        close()
    }
}

struct TranslationInputView: View {
    @State private var inputText: String = ""
    @FocusState private var isTextFieldFocused: Bool

    let onTranslate: (String) -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // 顶部标题栏
            HStack {
                YisinLogoShape()
                    .stroke(Color.primary, lineWidth: 1.5)
                    .frame(width: 24, height: 24)

                Text("Yisin")
                    .font(.system(size: 16, weight: .light))

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 16)

            // 输入区域
            VStack(alignment: .leading, spacing: 8) {
                Text("输入或粘贴要翻译的文本")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)

                TextEditor(text: $inputText)
                    .font(.system(size: 14))
                    .frame(height: 80)
                    .padding(8)
                    .background(Color(nsColor: .controlBackgroundColor))
                    .cornerRadius(6)
                    .focused($isTextFieldFocused)
            }
            .padding(.horizontal, 20)

            // 底部按钮
            HStack(spacing: 12) {
                Button("取消") {
                    onCancel()
                }
                .keyboardShortcut(.escape, modifiers: [])
                .buttonStyle(.plain)
                .foregroundColor(.secondary)

                Spacer()

                Button("翻译") {
                    if !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        onTranslate(inputText)
                    }
                }
                .keyboardShortcut(.return, modifiers: .command)
                .buttonStyle(.borderedProminent)
                .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(nsColor: .windowBackgroundColor))
        .onAppear {
            // 自动聚焦到输入框
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isTextFieldFocused = true
            }

            // 自动粘贴剪贴板内容
            if let clipboardText = NSPasteboard.general.string(forType: .string),
               !clipboardText.isEmpty {
                inputText = clipboardText
            }
        }
    }
}
