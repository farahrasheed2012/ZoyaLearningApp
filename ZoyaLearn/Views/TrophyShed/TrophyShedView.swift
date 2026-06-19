//
//  TrophyShedView.swift
//  ZoyaLearn
//

import SwiftUI

struct TrophyShedView: View {
    @EnvironmentObject var progressStore: ProgressStore
    @EnvironmentObject var avatarStore: AvatarStore
    @State private var showParentGate = false
    @State private var showParentDashboard = false

    private var avatar: Avatar { avatarStore.avatar ?? .defaultZoya }

    private var weatherMood: String {
        let recent = progressStore.currentStreak > 0 ? "sunny" : "cloudy"
        return recent == "sunny" ? "☀️ Sunny — lots of learning!" : "🌤 Gentle clouds — visit a friend on the map!"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    ZoyaAvatarView(avatar: avatar, expression: .happy, size: 56)
                    VStack(alignment: .leading) {
                        Text("Trophy Shed")
                            .font(ZLTheme.displayFont)
                            .foregroundStyle(ZLTheme.ink)
                        Text(weatherMood)
                            .font(ZLTheme.bodyFont)
                            .foregroundStyle(ZLTheme.earth)
                    }
                }

                StarJarView(count: progressStore.totalStars)

                shelf(title: "Letter blocks", items: LearningItemData.letters)
                shelf(title: "Number blocks", items: LearningItemData.numbers)

                Button("Parents tap here") {
                    showParentGate = true
                }
                .font(ZLTheme.bodyFont)
                .foregroundStyle(ZLTheme.earth)
                .frame(maxWidth: .infinity)
                .padding()
                .background(ZLTheme.whiteSoft)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding()
        }
        .background(
            LinearGradient(colors: [ZLTheme.earth.opacity(0.15), ZLTheme.cream], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
        .navigationTitle("Trophy Shed")
        .inlineNavTitle()
        .sheet(isPresented: $showParentGate) {
            ParentGateView(isUnlocked: $showParentDashboard)
        }
        .sheet(isPresented: $showParentDashboard) {
            ParentDashboardView()
                .environmentObject(progressStore)
        }
        .badgeAlert()
    }

    private func shelf(title: String, items: [LearningItem]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(ZLTheme.headingFont)
                .foregroundStyle(ZLTheme.ink)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 6), spacing: 8) {
                ForEach(items) { item in
                    let mastered = progressStore.progress(for: item.character).mastered
                    Button {
                        SpeechManager.shared.speakLetterAndWord(item)
                    } label: {
                        Text(item.character)
                            .font(.title3.bold())
                            .frame(maxWidth: .infinity, minHeight: 48)
                            .background(mastered ? ZLTheme.sun.opacity(0.35) : ZLTheme.earth.opacity(0.12))
                            .foregroundStyle(mastered ? ZLTheme.ink : ZLTheme.earth.opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(ZLTheme.earth.opacity(0.3), lineWidth: 1))
                    }
                    .buttonStyle(ScaleButtonStyle())
                    .disabled(!mastered)
                }
            }
        }
        .padding()
        .background(ZLTheme.whiteSoft.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}
