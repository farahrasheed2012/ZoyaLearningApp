//
//  FillBlankGameView.swift
//  ZoyaLearn
//

import SwiftUI

struct FillBlankGameView: View {
    @EnvironmentObject var progressStore: ProgressStore
    @State private var sequence: [LearningItem] = Array(LearningItemData.letters.prefix(5))
    @State private var missingIndex = 2
    @State private var choices: [LearningItem] = []
    @State private var filled = false
    @State private var score = 0
    @State private var round = 0

    var body: some View {
        VStack(spacing: 32) {
            Label("Fill in the blank", systemImage: "character.textbox")
                .font(ZLTheme.Game.prompt)

            HStack(spacing: 10) {
                ForEach(Array(sequence.enumerated()), id: \.offset) { idx, item in
                    if idx == missingIndex && !filled {
                        Text("__")
                            .font(ZLTheme.Game.blankSlot)
                            .frame(width: 56)
                    } else {
                        Text(idx == missingIndex && filled ? (choices.first(where: { $0.character == sequence[missingIndex].character })?.character ?? item.character) : item.character)
                            .font(ZLTheme.Game.blankSlot)
                            .foregroundStyle(idx == missingIndex && filled ? .green : .primary)
                    }
                }
            }

            VStack(spacing: 14) {
                ForEach(choices) { choice in
                    Button(choice.character) {
                        answer(choice)
                    }
                    .font(ZLTheme.Game.choice)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Capsule().fill(Color.accentColor.opacity(0.15)))
                    .buttonStyle(ScaleButtonStyle())
                    .disabled(filled)
                }
            }
            .padding(.horizontal)

            Label("Score: \(score) · Round \(round + 1)", systemImage: "star.fill")
                .font(ZLTheme.Game.progress)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding(.top, 32)
        .navigationTitle("Fill Blank")
        .inlineNavTitle()
        .onAppear { newRound() }
    }

    private func newRound() {
        filled = false
        let start = Int.random(in: 0...(LearningItemData.letters.count - 5))
        sequence = Array(LearningItemData.letters[start..<(start + 5)])
        missingIndex = Int.random(in: 1..<4)
        let correct = sequence[missingIndex]
        var opts = [correct]
        opts.append(contentsOf: LearningItemData.letters.filter { $0.character != correct.character }.shuffled().prefix(2))
        choices = opts.shuffled()
    }

    private func answer(_ choice: LearningItem) {
        let correct = sequence[missingIndex]
        filled = true
        if choice.character == correct.character {
            score += 1
            progressStore.addStars(1)
            HapticManager.success()
            withAnimation(.spring) { }
        } else {
            HapticManager.error()
        }
        round += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            newRound()
        }
    }
}
