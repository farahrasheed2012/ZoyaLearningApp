//
//  ZoyaAvatarView.swift
//  ZoyaLearn
//

import SwiftUI

struct ZoyaAvatarView: View {
    let avatar: Avatar
    var expression: AvatarExpression = .idle
    var size: CGFloat = 72

    @State private var bob = false
    @State private var walk = false

    var body: some View {
        ZStack {
            Ellipse()
                .fill(ZLTheme.earth.opacity(0.2))
                .frame(width: size * 0.9, height: size * 0.2)
                .offset(y: size * 0.42)

            VStack(spacing: 0) {
                ears
                animalBody
            }
            .offset(y: bob ? -3 : 3)
            .offset(x: walk ? 4 : 0)
        }
        .frame(width: size, height: size * 1.1)
        .onAppear { updateMotion() }
        .onChange(of: expression) { _, _ in updateMotion() }
    }

    private var ears: some View {
        HStack(spacing: size * 0.38) {
            ear
            ear
        }
        .offset(y: size * 0.08)
    }

    private var ear: some View {
        Circle()
            .fill(avatar.color.color.opacity(0.85))
            .frame(width: size * 0.22, height: size * 0.22)
    }

    private var animalBody: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.28)
                .fill(avatar.color.color)
                .frame(width: size * 0.72, height: size * 0.62)

            HStack(spacing: size * 0.16) {
                eye
                eye
            }
            .offset(y: -size * 0.06)

            mouth
                .offset(y: size * 0.12)

            if expression == .clapping || expression == .happy {
                Text("✨")
                    .font(.caption2)
                    .offset(x: size * 0.35, y: -size * 0.35)
            }
        }
    }

    private var eye: some View {
        ZStack {
            Circle().fill(ZLTheme.whiteSoft).frame(width: size * 0.14, height: size * 0.14)
            if expression == .thinking || expression == .shrug {
                Capsule().fill(ZLTheme.ink).frame(width: size * 0.1, height: 2)
            } else {
                Circle().fill(ZLTheme.ink).frame(width: size * 0.06, height: size * 0.06)
            }
        }
    }

    @ViewBuilder
    private var mouth: some View {
        switch expression {
        case .happy, .clapping:
            ArcSmile().stroke(ZLTheme.ink, lineWidth: 2).frame(width: size * 0.2, height: size * 0.1)
        case .shrug:
            Text("hmm").font(.caption2).foregroundStyle(ZLTheme.ink)
        default:
            Capsule().fill(ZLTheme.ink.opacity(0.7)).frame(width: size * 0.12, height: 2)
        }
    }

    private func updateMotion() {
        bob = false
        walk = false
        switch expression {
        case .idle, .thinking:
            withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) { bob = true }
        case .walking:
            withAnimation(.easeInOut(duration: 0.3).repeatForever(autoreverses: true)) { walk = true }
        case .happy, .clapping:
            withAnimation(.spring(response: 0.3, dampingFraction: 0.4)) { bob = true }
        default:
            break
        }
    }
}

private struct ArcSmile: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.minY), radius: rect.width / 2, startAngle: .degrees(20), endAngle: .degrees(160), clockwise: false)
        return path
    }
}
