import SwiftUI
import Carbon

struct HotkeyRecorderView: View {
    @Binding var hotkeyString: String
    @State private var isRecording = false
    @State private var recordedKeys: [String] = []

    var body: some View {
        HStack(spacing: 12) {
            Text(isRecording ? "按下快捷键..." : hotkeyString)
                .font(.system(size: 13, design: .monospaced))
                .foregroundColor(isRecording ? .blue : .primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(minWidth: 120)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(nsColor: .controlBackgroundColor))
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(isRecording ? Color.blue : Color.clear, lineWidth: 2)
                        )
                )

            Button(isRecording ? "取消" : "录制") {
                if isRecording {
                    stopRecording()
                } else {
                    startRecording()
                }
            }
            .buttonStyle(.plain)
            .foregroundColor(isRecording ? .red : .blue)
        }
        .onAppear {
            setupEventMonitor()
        }
    }

    private func startRecording() {
        isRecording = true
        recordedKeys = []
    }

    private func stopRecording() {
        isRecording = false
        recordedKeys = []
    }

    private func setupEventMonitor() {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            if isRecording {
                handleKeyEvent(event)
                return nil
            }
            return event
        }

        NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) { event in
            if isRecording {
                handleFlagsChanged(event)
            }
            return event
        }
    }

    private func handleKeyEvent(_ event: NSEvent) {
        guard let characters = event.charactersIgnoringModifiers?.uppercased() else {
            return
        }

        var components: [String] = []

        if event.modifierFlags.contains(.command) {
            components.append("⌘")
        }
        if event.modifierFlags.contains(.shift) {
            components.append("⇧")
        }
        if event.modifierFlags.contains(.option) {
            components.append("⌥")
        }
        if event.modifierFlags.contains(.control) {
            components.append("⌃")
        }

        components.append(characters)

        if components.count > 1 {
            hotkeyString = components.joined(separator: " ")
            isRecording = false
            recordedKeys = []
        }
    }

    private func handleFlagsChanged(_ event: NSEvent) {
        var components: [String] = []

        if event.modifierFlags.contains(.command) {
            components.append("⌘")
        }
        if event.modifierFlags.contains(.shift) {
            components.append("⇧")
        }
        if event.modifierFlags.contains(.option) {
            components.append("⌥")
        }
        if event.modifierFlags.contains(.control) {
            components.append("⌃")
        }

        recordedKeys = components
    }
}
