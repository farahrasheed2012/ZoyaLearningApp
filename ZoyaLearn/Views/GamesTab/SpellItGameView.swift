//
//  SpellItGameView.swift
//  ZoyaLearn
//

import SwiftUI

struct SpellItGameView: View {
    @EnvironmentObject var progressStore: ProgressStore
    @State private var target = PhonicsWordData.threeLetter.randomElement()!
    @State private var picked: [String] = []
    @State private var letterPool: [String] = []
    @State private var score = 0
    @State private var round = 0
    @State private var showResult = false
    @State private var wasCorrect = false

    var body: some View {
        VStack(spacing: 28) {
            Label("Spell the word", systemImage: "pencil.and.outline")
                .font(ZLTheme.Game.prompt)

            Text(target.emoji)
                .font(ZLTheme.Game.emoji)

            Text(target.hint)
                .font(ZLTheme.Game.progress)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            HStack(spacing: 10) {
                ForEach(0..<target.letterParts.count, id: \.self) { index in
                    Text(slotText(at: index))
                        .font(ZLTheme.Game.blankSlot)
                        .frame(width: 52, height: 64)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(showResult
                                      ? (wasCorrect ? Color.green.opacity(0.2) : Color.red.opacity(0.15))
                                      : Color.accentColor.opacity(0.1))
                        )
                }
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4), spacing: 10) {
                ForEach(Array(letterPool.enumerated()), id: \.offset) { index, letter in
                    if letter.isEmpty {
                        Color.clear.frame(height: 56)
                    } else {
                        Button(letter.uppercased()) {
                            tapLetter(at: index)
                        }
                        .font(ZLTheme.Game.choice)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(RoundedRectangle(cornerRadius: 12).fill(.background))
                        .buttonStyle(ScaleButtonStyle())
                        .disabled(showResult)
                    }
                }
            }
            .padding(.horizontal)

            HStack(spacing: 16) {
                Button {
                    undoLast()
                } label: {
                    Label("Undo", systemImage: "delete.left")
                        .font(ZLTheme.Game.progress)
                }
                .buttonStyle(.bordered)
                .disabled(picked.isEmpty || showResult)

                Button {
                    SpeechManager.shared.speakWord(target)
                } label: {
                    Label("Hint", systemImage: "speaker.wave.2")
                        .font(ZLTheme.Game.progress)
                }
                .buttonStyle(.bordered)
            }

            Label("Score: \(score) · Round \(round + 1)", systemImage: "star.fill")
                .font(ZLTheme.Game.progress)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding(.top, 24)
        .navigationTitle("Spell It")
        .inlineNavTitle()
        .onAppear { newRound() }
    }

    private func slotText(at index: Int) -> String {
        if index < picked.count { return picked[index].uppercased() }
        return "_"
    }

    private func tapLetter(at index: Int) {
        guard picked.count < target.letterParts.count else { return }
        let letter = letterPool[index]
        guard !letter.isEmpty else { return }
        picked.append(letter)
        letterPool[index] = ""

        if picked.count == target.letterParts.count {
            checkAnswer()
        }
    }

    private func undoLast() {
        guard let last = picked.popLast() else { return }
        if let emptyIndex = letterPool.firstIndex(of: "") {
            letterPool[emptyIndex] = last
        }
    }

    private func checkAnswer() {
        let attempt = picked.joined().lowercased()
        wasCorrect = attempt == target.word.lowercased()
        showResult = true
        round += 1
        if wasCorrect {
            score += 1
            progressStore.addStars(1)
            progressStore.markPhonicsPracticed(target.word)
            HapticManager.success()
        } else {
            HapticManager.error()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            newRound()
        }
    }

    private func newRound() {
        showResult = false
        wasCorrect = false
        picked = []
        target = PhonicsWordData.all.randomElement()!
        var pool = target.letterParts
        pool.append(contentsOf: "abcdefghijklmnopqrstuvwxyz".map(String.init).shuffled().prefix(4))
        letterPool = pool.shuffled()
    }
}
