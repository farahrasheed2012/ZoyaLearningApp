//
//  MapLocationNode.swift
//  ZoyaLearn
//

import SwiftUI

struct MapLocationNode: View {
    let location: MapLocation
    let isUnlocked: Bool
    let isVisited: Bool
    var onTap: () -> Void

    @State private var sway = false
    @State private var puff = false

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(isUnlocked ? ZLTheme.whiteSoft : ZLTheme.cream.opacity(0.6))
                        .frame(width: 76, height: 76)
                        .shadow(color: ZLTheme.earth.opacity(0.2), radius: 6, y: 3)
                        .overlay(
                            Circle()
                                .stroke(ZLTheme.earth.opacity(0.4), lineWidth: 2)
                        )
                        .saturation(isUnlocked ? 1 : 0.35)

                    Text(location.emoji)
                        .font(.largeTitle)
                        .rotationEffect(.degrees(sway ? 2 : -2))

                    if !isUnlocked {
                        Text("?")
                            .font(.title3.bold())
                            .foregroundStyle(ZLTheme.earth)
                    }

                    if isVisited {
                        Text("✓")
                            .font(.caption.bold())
                            .foregroundStyle(ZLTheme.grass)
                            .offset(x: 28, y: -28)
                    }
                }

                Text(location.title)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(ZLTheme.ink)
                    .multilineTextAlignment(.center)
                    .frame(width: 100)
            }
        }
        .buttonStyle(ScaleButtonStyle())
        .disabled(!isUnlocked)
        .onAppear {
            withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true)) { sway = true }
            if location == .letterHouse {
                withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) { puff = true }
            }
        }
        .overlay(alignment: .top) {
            if location == .letterHouse && puff {
                Text("💨")
                    .font(.caption2)
                    .offset(y: -8)
                    .opacity(0.7)
            }
        }
    }
}
