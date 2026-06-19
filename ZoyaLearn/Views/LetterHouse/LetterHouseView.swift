//
//  LetterHouseView.swift
//  ZoyaLearn
//

import SwiftUI

struct LetterHouseView: View {
    @EnvironmentObject var progressStore: ProgressStore
    @EnvironmentObject var avatarStore: AvatarStore
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = LearningViewModel()
    @State private var showRoom = false

    private var avatar: Avatar { avatarStore.avatar ?? .defaultZoya }

    var body: some View {
        ZStack {
            ZLTheme.cream.ignoresSafeArea()

            if showRoom, let item = viewModel.currentItem {
                roomInterior(item: item)
            } else {
                hallway
            }
        }
        .navigationTitle("Letter House")
        .inlineNavTitle()
        .toolbar {
            ToolbarItem(placement: ZLToolbar.leading) {
                if showRoom {
                    Button("Hallway") { withAnimation { showRoom = false } }
                }
            }
        }
        .onAppear {
            viewModel.setFilter(.letters)
            viewModel.syncDisplayOrder()
            viewModel.animateCardEntrance()
            openLessonLetterIfNeeded()
        }
        .onChange(of: appState.lessonFocusCharacter) { _, _ in
            openLessonLetterIfNeeded()
        }
        .badgeAlert()
    }

    private func openLessonLetterIfNeeded() {
        guard let focus = appState.lessonFocusCharacter else { return }
        viewModel.jumpTo(focus)
        viewModel.applyJumpIfNeeded()
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            showRoom = true
        }
        progressStore.markSeen(focus)
    }

    private var hallway: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Pick a door to explore!")
                    .font(ZLTheme.headingFont)
                    .foregroundStyle(ZLTheme.ink)

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 88), spacing: 12)], spacing: 12) {
                    ForEach(Array(viewModel.items.enumerated()), id: \.element.id) { _, item in
                        let mastered = progressStore.progress(for: item.character).mastered
                        Button {
                            viewModel.jumpTo(item.character)
                            viewModel.applyJumpIfNeeded()
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                showRoom = true
                            }
                            progressStore.markSeen(item.character)
                        } label: {
                            VStack(spacing: 6) {
                                Text(item.displayPair)
                                    .font(.title.bold())
                                    .foregroundStyle(mastered ? ZLTheme.sun : ZLTheme.ink)
                                Text(item.exampleEmoji)
                                    .font(.title2)
                            }
                            .frame(maxWidth: .infinity, minHeight: 88)
                            .background(mastered ? ZLTheme.sun.opacity(0.2) : ZLTheme.whiteSoft)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(ZLTheme.earth.opacity(0.35), lineWidth: 2))
                            .shadow(color: mastered ? ZLTheme.sun.opacity(0.3) : .clear, radius: 8)
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
            }
            .padding()
        }
    }

    private func roomInterior(item: LearningItem) -> some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack {
                    ZoyaAvatarView(avatar: avatar, expression: .happy, size: 48)
                    Text("Zoya is exploring room \(item.displayPair)!")
                        .font(ZLTheme.bodyFont)
                        .foregroundStyle(ZLTheme.earth)
                    Spacer(minLength: 0)
                }

                CharacterCardView(
                    item: item,
                    scale: viewModel.cardScale,
                    showLearnedButton: true,
                    isLearned: progressStore.progress(for: item.character).mastered,
                    onMarkLearned: {
                        progressStore.markMastered(item.character)
                        progressStore.addStars(1)
                        SoundManager.shared.playChime()
                        HapticManager.success()
                    },
                    onTapCharacter: {
                        SoundManager.shared.playWoodTap()
                    }
                )
                .gesture(swipeGesture)

                roomNavigation
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
        .scrollIndicators(.hidden)
    }

    private var roomNavigation: some View {
        HStack(spacing: 20) {
            Button { viewModel.goPrevious() } label: { Image(systemName: "door.left.hand.open") }
            Text("\(viewModel.currentIndex + 1) of \(viewModel.items.count)")
                .font(ZLTheme.bodyFont)
            Button { viewModel.goNext() } label: { Image(systemName: "door.right.hand.open") }
        }
        .font(.title2)
        .foregroundStyle(ZLTheme.earth)
        #if os(macOS)
        .onMoveCommand { direction in
            if direction == .left { viewModel.goPrevious() }
            if direction == .right { viewModel.goNext() }
        }
        #endif
    }

    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 40)
            .onEnded { value in
                if value.translation.width < -40 { viewModel.goNext() }
                else if value.translation.width > 40 { viewModel.goPrevious() }
            }
    }
}
