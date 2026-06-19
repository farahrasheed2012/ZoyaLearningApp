//
//  LibraryTreeView.swift
//  ZoyaLearn
//

import SwiftUI

struct LibraryTreeView: View {
    @EnvironmentObject var progressStore: ProgressStore
    @EnvironmentObject var avatarStore: AvatarStore
    @State private var selectedItem: LearningItem?
    @State private var showFireflyFact = false
    @State private var fireflyFact = ""
    @State private var showQuiz = false

    private var avatar: Avatar { avatarStore.avatar ?? .defaultZoya }

    var body: some View {
        ZStack {
            ZLTheme.backgroundGradient.ignoresSafeArea()

            if let item = selectedItem {
                bookOpen(item: item)
            } else {
                treeShelf
            }

            if showFireflyFact {
                VStack {
                    Spacer()
                    Text("✨ \(fireflyFact)")
                        .font(ZLTheme.bodyFont)
                        .padding()
                        .background(ZLTheme.whiteSoft)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding()
                }
                .transition(.opacity)
            }
        }
        .navigationTitle("Library Tree")
        .inlineNavTitle()
        .toolbar {
            ToolbarItem(placement: ZLToolbar.trailing) {
                Button("Catch firefly ✨") { catchFirefly() }
            }
        }
    }

    private var treeShelf: some View {
        ScrollView {
            VStack(spacing: 20) {
                extraLearningLinks

                Text("Tap a book on the branch!")
                    .font(ZLTheme.headingFont)
                    .foregroundStyle(ZLTheme.ink)

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 72), spacing: 12)], spacing: 12) {
                    ForEach(LearningItemData.all) { item in
                        let mastered = progressStore.progress(for: item.character).mastered
                        Button {
                            progressStore.markSeen(item.character)
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                                selectedItem = item
                            }
                        } label: {
                            VStack(spacing: 4) {
                                Text("📕")
                                    .font(.largeTitle)
                                    .shadow(color: mastered ? ZLTheme.sun.opacity(0.6) : .clear, radius: 6)
                                Text(item.type == .letter ? item.displayPair : item.character)
                                    .font(.headline)
                                    .foregroundStyle(ZLTheme.ink)
                            }
                            .frame(maxWidth: .infinity, minHeight: 80)
                            .background(ZLTheme.whiteSoft)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(ZLTheme.earth.opacity(0.3), lineWidth: 2))
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
            }
            .padding()
        }
    }

    private var extraLearningLinks: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("More ways to learn")
                .font(ZLTheme.headingFont)
                .foregroundStyle(ZLTheme.ink)

            HStack(spacing: 12) {
                NavigationLink {
                    PhonicsView()
                } label: {
                    linkTile(title: "Phonics", icon: "text.book.closed.fill", tint: ZLTheme.grass)
                }

                NavigationLink {
                    FlashcardsStudyView()
                } label: {
                    linkTile(title: "Flashcards", icon: "rectangle.stack.fill", tint: ZLTheme.sun)
                }
            }
        }
    }

    private func linkTile(title: String, icon: String, tint: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(tint)
            Text(title)
                .font(ZLTheme.bodyFont)
                .foregroundStyle(ZLTheme.ink)
        }
        .frame(maxWidth: .infinity, minHeight: 88)
        .background(ZLTheme.whiteSoft)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(tint.opacity(0.35), lineWidth: 2))
    }

    private func bookOpen(item: LearningItem) -> some View {
        let progress = progressStore.progress(for: item.character)
        let isLetter = item.type == .letter

        return VStack(spacing: 20) {
            HStack {
                Button("Back to tree") { selectedItem = nil }
                Spacer()
                ZoyaAvatarView(avatar: avatar, expression: .thinking, size: 48)
            }
            .padding(.horizontal)

            VStack(spacing: 16) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(item.character)
                        .font(ZLTheme.letterFont)
                        .foregroundStyle(ZLTheme.accent(for: item.character))
                    if isLetter {
                        Text(item.lowercaseCharacter)
                            .font(.system(size: 56, weight: .bold, design: .rounded))
                            .foregroundStyle(ZLTheme.accent(for: item.character).opacity(0.85))
                    }
                }

                if isLetter {
                    Text("Says /\(item.soundLabel)/")
                        .font(ZLTheme.headingFont)
                        .foregroundStyle(ZLTheme.grass)
                }

                IllustratedObjectView(item: item)
                Text(item.exampleWord)
                    .font(ZLTheme.displayFont)
                    .foregroundStyle(ZLTheme.ink)
                Text(item.funFact)
                    .font(ZLTheme.bodyFont)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(ZLTheme.earth)
                    .padding(.horizontal)
            }
            .zlCardStyle()
            .padding()

            HStack(spacing: 16) {
                Button("Read it again") {
                    SpeechManager.shared.speakLetterAndWord(item)
                }
                .buttonStyle(.bordered)

                masteryButton(item: item, progress: progress)
            }
            .buttonStyle(ScaleButtonStyle())
        }
        .sheet(isPresented: $showQuiz) {
            LetterQuizView(
                item: item,
                onPass: {
                    progressStore.markQuizPassed(item.character)
                    showQuiz = false
                },
                onDismiss: { showQuiz = false }
            )
        }
    }

    @ViewBuilder
    private func masteryButton(item: LearningItem, progress: CharacterProgress) -> some View {
        if progress.mastered {
            Label("Mastered ⭐️", systemImage: "star.fill")
                .font(ZLTheme.bodyFont)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(ZLTheme.grass.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 14))
        } else if item.type == .letter, !progress.practiced {
            Text("Trace at Art Corner first")
                .font(ZLTheme.bodyFont)
                .foregroundStyle(ZLTheme.earth)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(ZLTheme.earth.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 14))
        } else if item.type == .letter, !progress.quizPassed {
            Button("Letter quiz!") { showQuiz = true }
                .buttonStyle(.borderedProminent)
                .tint(ZLTheme.grass)
        } else {
            Button("I know this one! ⭐️") {
                progressStore.markMastered(item.character)
                progressStore.recordFlashcardKnown()
                SoundManager.shared.playChime()
                HapticManager.success()
                selectedItem = nil
            }
            .buttonStyle(.borderedProminent)
            .tint(ZLTheme.grass)
            .disabled(!progressStore.canEarnMastered(for: item.character))
        }
    }

    private func catchFirefly() {
        if let item = LearningItemData.all.randomElement() {
            fireflyFact = item.funFact
            showFireflyFact = true
            SoundManager.shared.playWaterDrop()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation { showFireflyFact = false }
            }
        }
    }
}
