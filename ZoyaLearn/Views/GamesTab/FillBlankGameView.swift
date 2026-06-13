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
    @State private var wasCorrect = false
    @State private var selectedChoice: LearningItem?
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
                    } else if idx == missingIndex && filled, let choice = selectedChoice {
                        Text(choice.character)
                            .font(ZLTheme.Game.blankSlot)
                            .foregroundStyle(wasCorrect ? .green : .red)
                    } else {
                        Text(item.character)
                            .font(ZLTheme.Game.blankSlot)
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

            if filled && !wasCorrect {
                Text("The answer was \(sequence[missingIndex].character)")
                    .font(ZLTheme.Game.progress)
                    .foregroundStyle(.secondary)
            }

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
        wasCorrect = false
        selectedChoice = nil
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
        selectedChoice = choice
        filled = true
        wasCorrect = choice.character == correct.character
        round += 1
        if wasCorrect {
            score += 1
            progressStore.addStars(1)
            HapticManager.success()
        } else {
            HapticManager.error()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            newRound()
        }
    }
}
