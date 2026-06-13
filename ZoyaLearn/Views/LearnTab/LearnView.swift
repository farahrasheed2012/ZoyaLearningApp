//
//  LearnView.swift
//  ZoyaLearn
//

import SwiftUI

struct LearnView: View {
    @EnvironmentObject var progressStore: ProgressStore
    @StateObject private var viewModel = LearningViewModel()
    @State private var hueShift: Double = 0

    var body: some View {
        ZStack {
            animatedBackground
            VStack(spacing: 20) {
                Picker("Content", selection: $viewModel.filter) {
                    ForEach(ContentFilter.allCases) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .onChange(of: viewModel.filter) { _, _ in
                    viewModel.currentIndex = 0
                    viewModel.syncDisplayOrder()
                    viewModel.animateCardEntrance()
                }

                if let item = viewModel.currentItem {
                    CharacterCard(
                        item: item,
                        scale: viewModel.cardScale,
                        showLearnedButton: true,
                        isLearned: progressStore.progress(for: item.character).mastered,
                        onMarkLearned: {
                            progressStore.markMastered(item.character)
                            progressStore.addStars(1)
                            HapticManager.success()
                        }
                    )
                    .padding(.horizontal)
                    .gesture(swipeGesture)

                    navigationRow
                } else {
                    ContentUnavailableView("No items", systemImage: "book")
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Learn")
        .largeNavTitle()
        .onAppear {
            viewModel.syncDisplayOrder()
            viewModel.animateCardEntrance()
            if let item = viewModel.currentItem {
                progressStore.markSeen(item.character)
            }
            withAnimation(.linear(duration: 12).repeatForever(autoreverses: true)) {
                hueShift = 1
            }
        }
        .onChange(of: viewModel.currentIndex) { _, _ in
            if let item = viewModel.currentItem {
                progressStore.markSeen(item.character)
            }
        }
        .onChange(of: viewModel.jumpToCharacter) { _, _ in
            viewModel.applyJumpIfNeeded()
        }
        .onReceive(NotificationCenter.default.publisher(for: .zlJumpToCharacter)) { note in
            if let c = note.object as? String {
                viewModel.jumpTo(c)
                viewModel.applyJumpIfNeeded()
            }
        }
        #if os(macOS)
        .onMoveCommand { direction in
            switch direction {
            case .left: viewModel.goPrevious()
            case .right: viewModel.goNext()
            default: break
            }
        }
        #endif
        .badgeAlert()
    }

    private var animatedBackground: some View {
        ZLTheme.backgroundGradient
            .hueRotation(.degrees(hueShift * 8))
            .ignoresSafeArea()
    }

    private var navigationRow: some View {
        VStack(spacing: 14) {
            HStack(spacing: 16) {
                navButton(title: "Previous", systemImage: "chevron.left") {
                    viewModel.goPrevious()
                }
                .accessibilityLabel("Previous letter or number")

                Text("\(viewModel.currentIndex + 1) of \(viewModel.items.count)")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .frame(minWidth: 88)

                navButton(title: "Next", systemImage: "chevron.right") {
                    viewModel.goNext()
                }
                .accessibilityLabel("Next letter or number")
            }

            HStack(spacing: 12) {
                navButton(title: "Shuffle", systemImage: "shuffle") {
                    viewModel.shuffleOrder()
                    HapticManager.lightImpact()
                }
                .accessibilityLabel("Shuffle the learning order")

                navButton(title: "Random", systemImage: "dice.fill") {
                    viewModel.goRandom()
                    HapticManager.lightImpact()
                }
                .accessibilityLabel("Jump to a random card")
            }
        }
        .padding(.horizontal)
    }

    private func navButton(title: String, systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Capsule().fill(Color.accentColor.opacity(0.14)))
        }
        .buttonStyle(ScaleButtonStyle())
        .foregroundStyle(Color.accentColor)
    }

    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 40)
            .onEnded { value in
                if value.translation.width < -40 { viewModel.goNext() }
                else if value.translation.width > 40 { viewModel.goPrevious() }
            }
    }
}

extension Notification.Name {
    static let zlJumpToCharacter = Notification.Name("zlJumpToCharacter")
}

struct BadgeAlertModifier: ViewModifier {
    @EnvironmentObject var progressStore: ProgressStore

    func body(content: Content) -> some View {
        content
            .overlay {
                if progressStore.newlyUnlockedBadge != nil {
                    ConfettiView(isActive: true)
                }
            }
            .alert("New Badge!", isPresented: Binding(
                get: { progressStore.newlyUnlockedBadge != nil },
                set: { if !$0 { progressStore.clearNewBadgeAlert() } }
            )) {
                Button("Awesome!") {
                    progressStore.clearNewBadgeAlert()
                }
            } message: {
                if let badge = progressStore.newlyUnlockedBadge {
                    Text("\(badge.emoji) \(badge.title)")
                }
            }
            .onChange(of: progressStore.newlyUnlockedBadge) { _, badge in
                if let badge {
                    SpeechManager.shared.speakBadgeUnlock(badge)
                }
            }
    }
}

extension View {
    func badgeAlert() -> some View {
        modifier(BadgeAlertModifier())
    }
}
