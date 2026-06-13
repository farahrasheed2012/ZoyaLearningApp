//
//  BadgeView.swift
//  ZoyaLearn
//

import SwiftUI

struct BadgeView: View {
    let badge: Badge
    let isUnlocked: Bool

    var body: some View {
        VStack(spacing: 8) {
            Text(badge.emoji)
                .font(.system(size: 40))
                .grayscale(isUnlocked ? 0 : 1)
                .opacity(isUnlocked ? 1 : 0.35)
            Text(badge.title)
                .font(.caption.weight(.semibold))
                .multilineTextAlignment(.center)
            Text("\(badge.starsRequired) ⭐")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 16).fill(.background))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isUnlocked ? Color.yellow : Color.gray.opacity(0.3), lineWidth: 2)
        )
        .accessibilityLabel("\(badge.title), \(isUnlocked ? "unlocked" : "locked"), requires \(badge.starsRequired) stars")
    }
}

struct TrophyShelfView: View {
    let unlockedIDs: Set<String>

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 110), spacing: 12)], spacing: 12) {
            ForEach(BadgeCatalog.all) { badge in
                BadgeView(badge: badge, isUnlocked: unlockedIDs.contains(badge.id))
            }
        }
    }
}
