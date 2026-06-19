//
//  BackyardView.swift
//  ZoyaLearn
//

import SwiftUI

struct BackyardView: View {
    @EnvironmentObject var avatarStore: AvatarStore

    private var avatar: Avatar { avatarStore.avatar ?? .defaultZoya }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                HStack {
                    ZoyaAvatarView(avatar: avatar, expression: .happy, size: 64)
                    VStack(alignment: .leading) {
                        Text("The Backyard")
                            .font(ZLTheme.displayFont)
                            .foregroundStyle(ZLTheme.ink)
                        Text("Pick something to play!")
                            .font(ZLTheme.bodyFont)
                            .foregroundStyle(ZLTheme.earth)
                    }
                    Spacer()
                }
                .padding(.horizontal)

                ForEach(GameCategory.allCases, id: \.self) { category in
                    VStack(alignment: .leading, spacing: 12) {
                        Label(category.rawValue, systemImage: category == .letters ? "textformat.abc" : "text.book.closed.fill")
                            .font(ZLTheme.headingFont)
                            .foregroundStyle(ZLTheme.ink)
                            .padding(.horizontal)

                        ForEach(MiniGame.allCases.filter { $0.category == category }) { game in
                            NavigationLink {
                                game.destination
                                    .navigationTitle(game.backyardTitle)
                            } label: {
                                backyardCard(game: game)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
        .background(ZLTheme.grass.opacity(0.12).ignoresSafeArea())
        .navigationTitle("Backyard")
        .inlineNavTitle()
    }

    private func backyardCard(game: MiniGame) -> some View {
        HStack(spacing: 16) {
            Text(game.backyardEmoji)
                .font(.system(size: 44))
            VStack(alignment: .leading, spacing: 4) {
                Text(game.backyardTitle)
                    .font(ZLTheme.headingFont)
                    .foregroundStyle(ZLTheme.ink)
                Text(game.backyardSubtitle)
                    .font(ZLTheme.bodyFont)
                    .foregroundStyle(ZLTheme.earth)
            }
            Spacer()
            Image(systemName: "chevron.right.circle.fill")
                .foregroundStyle(ZLTheme.grass)
        }
        .padding(20)
        .background(ZLTheme.whiteSoft)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(ZLTheme.earth.opacity(0.25), lineWidth: 2))
    }
}
