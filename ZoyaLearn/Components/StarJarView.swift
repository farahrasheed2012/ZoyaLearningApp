//
//  StarJarView.swift
//  ZoyaLearn
//

import SwiftUI

struct StarJarView: View {
    let count: Int
    var bounce: Bool = false

    var body: some View {
        HStack(spacing: 6) {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(ZLTheme.earth.opacity(0.5), lineWidth: 2)
                    .frame(width: 36, height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(ZLTheme.warmSky.opacity(0.25))
                    )
                Text("⭐️")
                    .font(.caption)
                    .offset(y: -6)
            }
            Text("\(count)")
                .font(ZLTheme.bodyFont)
                .foregroundStyle(ZLTheme.ink)
        }
        .scaleEffect(bounce ? 1.15 : 1)
        .animation(.spring(response: 0.35, dampingFraction: 0.45), value: bounce)
        .accessibilityLabel("\(count) stars in the jar")
    }
}

struct FloatingStarParticle: View {
    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 1

    var body: some View {
        Text("⭐️")
            .font(.title3)
            .offset(y: offset)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeOut(duration: 0.9)) {
                    offset = -80
                    opacity = 0
                }
            }
    }
}
