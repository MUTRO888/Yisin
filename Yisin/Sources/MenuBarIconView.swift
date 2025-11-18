import SwiftUI

struct MenuBarIconView: View {
    let state: MenuBarIconState
    @State private var animationPhase: CGFloat = 0

    var body: some View {
        ZStack {
            switch state {
            case .idle:
                idleIcon
            case .listening:
                listeningIcon
            case .thinking:
                thinkingIcon
            case .completed:
                completedIcon
            }
        }
        .frame(width: 18, height: 18)
    }

    private var idleIcon: some View {
        YisinLogoShape()
            .stroke(Color.primary, lineWidth: 1.2)
    }

    private var listeningIcon: some View {
        YisinLogoShape()
            .stroke(Color.blue, lineWidth: 1.2)
            .scaleEffect(1.0 + sin(animationPhase) * 0.1)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                    animationPhase = .pi * 2
                }
            }
    }

    private var thinkingIcon: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(Color.blue, lineWidth: 1.5)
            .rotationEffect(.degrees(animationPhase * 360 / (.pi * 2)))
            .onAppear {
                withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                    animationPhase = .pi * 2
                }
            }
    }

    private var completedIcon: some View {
        YisinLogoShape()
            .stroke(Color.green, lineWidth: 1.2)
            .scaleEffect(1.2)
            .opacity(0)
            .onAppear {
                withAnimation(.easeOut(duration: 0.3)) {
                    animationPhase = 1
                }
            }
    }
}

struct YisinLogoShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.width
        let height = rect.height
        let centerY = height / 2

        let topY = centerY - height * 0.15
        let bottomY = centerY + height * 0.15

        path.move(to: CGPoint(x: width * 0.15, y: topY))
        path.addQuadCurve(
            to: CGPoint(x: width * 0.85, y: topY),
            control: CGPoint(x: width * 0.5, y: topY - height * 0.25)
        )

        path.move(to: CGPoint(x: width * 0.85, y: bottomY))
        path.addQuadCurve(
            to: CGPoint(x: width * 0.15, y: bottomY),
            control: CGPoint(x: width * 0.5, y: bottomY + height * 0.25)
        )

        return path
    }
}
