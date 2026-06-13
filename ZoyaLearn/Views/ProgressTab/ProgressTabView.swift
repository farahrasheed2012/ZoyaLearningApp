//
//  ProgressTabView.swift
//  ZoyaLearn
//

import SwiftUI

struct ProgressTabView: View {
    @EnvironmentObject var progressStore: ProgressStore
    @State private var showParentGate = false
    @State private var showParentDashboard = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                starsHeader
                progressRings
                characterGrid(title: "Letters", items: LearningItemData.letters)
                characterGrid(title: "Numbers", items: LearningItemData.numbers)
                trophySection
                parentButton
            }
            .padding()
        }
        .background(ZLPlatformColor.groupedBackground)
        .navigationTitle("Progress")
        .largeNavTitle()
        .sheet(isPresented: $showParentDashboard) {
            ParentDashboardView()
                .environmentObject(progressStore)
        }
        .badgeAlert()
    }

    private var starsHeader: some View {
        HStack {
            Text("⭐️ \(progressStore.totalStars) stars")
                .font(.title.bold())
            Spacer()
            Text("🔥 \(progressStore.currentStreak) day streak")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
    }

    private var progressRings: some View {
        HStack(spacing: 20) {
            ring(label: "Letters", value: progressStore.letterMasteryPercent, color: .orange)
            ring(label: "Numbers", value: progressStore.numberMasteryPercent, color: .blue)
        }
    }

    private func ring(label: String, value: Double, color: Color) -> some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: 10)
                Circle()
                    .trim(from: 0, to: value / 100)
                    .stroke(color, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                Text("\(Int(value))%")
                    .font(.headline)
            }
            .frame(width: 100, height: 100)
            Text(label)
                .font(.subheadline.weight(.semibold))
        }
        .frame(maxWidth: .infinity)
    }

    private func characterGrid(title: String, items: [LearningItem]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 9), spacing: 8) {
                ForEach(items) { item in
                    Button {
                        NotificationCenter.default.post(name: .zlJumpToCharacter, object: item.character)
                    } label: {
                        Text(item.character)
                            .font(.headline.bold())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(color(for: item).opacity(0.25))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .buttonStyle(ScaleButtonStyle())
                    .accessibilityLabel("\(item.character), \(progressStore.masteryLevel(for: item.character).rawValue)")
                }
            }
        }
    }

    private func color(for item: LearningItem) -> Color {
        switch progressStore.masteryLevel(for: item.character) {
        case .notSeen: return .gray
        case .inProgress: return .yellow
        case .mastered: return .green
        }
    }

    private var trophySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Trophy Shelf")
                .font(.headline)
            TrophyShelfView(unlockedIDs: progressStore.unlockedBadgeIDs)
        }
    }

    private var parentButton: some View {
        Button("Parent Dashboard") {
            showParentGate = true
        }
        .buttonStyle(.bordered)
        .frame(maxWidth: .infinity)
        .sheet(isPresented: $showParentGate) {
            ParentGateView(isUnlocked: $showParentDashboard)
        }
    }
}
