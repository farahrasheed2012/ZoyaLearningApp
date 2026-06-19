//
//  ArtCornerView.swift
//  ZoyaLearn
//

import SwiftUI

struct ArtCornerView: View {
    @EnvironmentObject var progressStore: ProgressStore
    @EnvironmentObject var avatarStore: AvatarStore

    private var avatar: Avatar { avatarStore.avatar ?? .defaultZoya }

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                HStack(spacing: 10) {
                    ZoyaAvatarView(avatar: avatar, expression: .thinking, size: 48)
                    Text("\(avatar.name) is watching you trace!")
                        .font(ZLTheme.bodyFont)
                        .foregroundStyle(ZLTheme.ink)
                    Spacer(minLength: 0)
                }
                .padding(.horizontal)

                TraceView(embeddedInArtCorner: true)
            }
            .padding(.vertical, 8)
        }
        .scrollIndicators(.hidden)
        .background(
            LinearGradient(colors: [ZLTheme.cream, ZLTheme.sun.opacity(0.15)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
        .navigationTitle("Art Corner")
        .inlineNavTitle()
    }
}
