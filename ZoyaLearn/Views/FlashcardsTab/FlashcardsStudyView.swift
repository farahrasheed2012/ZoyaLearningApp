//
//  FlashcardsStudyView.swift
//  ZoyaLearn
//

import SwiftUI

struct FlashcardsStudyView: View {
    @EnvironmentObject var progressStore: ProgressStore
    @State private var deck: [LearningItem] = LearningItemData.letters.shuffled()
    @State private var index = 0
    @State private var isFlipped = false
    @State private var flipDegrees: Double = 0
    @State private var showQuiz = false

    private var item: LearningItem { deck[min(index, max(deck.count - 1, 0))] }

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("🔥 \(progressStore.flashcardStreak) in a row!")
                    .font(.headline)
                Spacer()
                Text("⭐️ \(progressStore.totalStars)")
            }
            .padding(.horizontal)

            ZStack {
                cardFace(isBack: false)
                    .opacity(isFlipped ? 0 : 1)
                    .rotation3DEffect(.degrees(flipDegrees), axis: (x: 0, y: 1, z: 0))
                cardFace(isBack: true)
                    .opacity(isFlipped ? 1 : 0)
                    .rotation3DEffect(.degrees(flipDegrees - 180), axis: (x: 0, y: 1, z: 0))
            }
            .frame(height: 340)
            .padding(.horizontal)
            .onTapGesture { flipCard() }
            .accessibilityLabel(isFlipped ? "Back of card" : "Front of card")
            .accessibilityHint("Double tap to flip")

            HStack(spacing: 12) {
                Button("Still learning") {
                    progressStore.markStillLearning(item.character)
                    progressStore.recordFlashcardLearning()
                    nextCard()
                }
                .buttonStyle(.bordered)

                Button("I know this!") {
                    handleKnowThis()
                }
                .buttonStyle(.borderedProminent)
                .disabled(!canMarkKnown)
            }
            .buttonStyle(ScaleButtonStyle())
            .padding(.horizontal)

            HStack {
                Button {
                    deck.shuffle()
                    index = 0
                    isFlipped = false
                    flipDegrees = 0
                } label: {
                    Label("Shuffle", systemImage: "shuffle")
                }
                Spacer()
                Text("\(index + 1) / \(deck.count)")
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 24)
        }
        .navigationTitle("Flashcards")
        .inlineNavTitle()
        #if os(macOS)
        .onMoveCommand { direction in
            if direction == .left { previousCard() }
            if direction == .right { nextCard() }
        }
        #endif
        .sheet(isPresented: $showQuiz) {
            LetterQuizView(
                item: item,
                onPass: {
                    progressStore.markQuizPassed(item.character)
                    progressStore.markMastered(item.character)
                    progressStore.recordFlashcardKnown()
                    showQuiz = false
                    nextCard()
                },
                onDismiss: { showQuiz = false }
            )
        }
    }

    private var canMarkKnown: Bool {
        progressStore.canEarnMastered(for: item.character)
            || (item.type == .letter && progressStore.progress(for: item.character).practiced && !progressStore.progress(for: item.character).quizPassed)
    }

    private func handleKnowThis() {
        let p = progressStore.progress(for: item.character)
        if item.type == .letter, p.practiced, !p.quizPassed {
            showQuiz = true
        } else if progressStore.canEarnMastered(for: item.character) {
            progressStore.markMastered(item.character)
            progressStore.recordFlashcardKnown()
            HapticManager.success()
            nextCard()
        }
    }

    @ViewBuilder
    private func cardFace(isBack: Bool) -> some View {
        VStack(spacing: 16) {
            if isBack {
                Text(item.exampleWord)
                    .font(.system(.largeTitle, design: .rounded).weight(.bold))
                Text(item.funFact)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
            } else {
                Text(item.exampleEmoji).font(.system(size: 72))
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(item.character)
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .foregroundStyle(ZLTheme.accent(for: item.character))
                    if item.type == .letter {
                        Text(item.lowercaseCharacter)
                            .font(.system(size: 52, weight: .bold, design: .rounded))
                            .foregroundStyle(ZLTheme.accent(for: item.character).opacity(0.85))
                    }
                }
                if item.type == .letter {
                    Text("/\(item.soundLabel)/")
                        .font(.headline)
                        .foregroundStyle(ZLTheme.grass)
                }
                Text("Tap to flip")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .zlCardStyle(accent: ZLTheme.accent(for: item.character))
    }

    private func flipCard() {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
            flipDegrees += 180
            isFlipped.toggle()
        }
    }

    private func nextCard() {
        guard !deck.isEmpty else { return }
        index = (index + 1) % deck.count
        isFlipped = false
        flipDegrees = 0
    }

    private func previousCard() {
        guard !deck.isEmpty else { return }
        index = (index - 1 + deck.count) % deck.count
        isFlipped = false
        flipDegrees = 0
    }
}
