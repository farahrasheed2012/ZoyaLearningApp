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
        VStack(spacing: 28) {
            Text("Fill in the blank")
                .font(.title2.bold())

            HStack(spacing: 8) {
                ForEach(Array(sequence.enumerated()), id: \.offset) { idx, item in
                    if idx == missingIndex && !filled {
                        Text("__")
                            .font(.system(size: 44, weight: .bold, design: .rounded))
                            .frame(width: 48)
                    } else {
                        Text(idx == missingIndex && filled ? (choices.first(where: { $0.character == sequence[missingIndex].character })?.character ?? item.character) : item.character)
                            .font(.system(size: 44, weight: .bold, design: .rounded))
                            .foregroundStyle(idx == missingIndex && filled ? .green : .primary)
                    }
                }
            }

            VStack(spacing: 12) {
                ForEach(choices) { choice in
                    Button(choice.character) {
                        answer(choice)
                    }
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Capsule().fill(Color.accentColor.opacity(0.15)))
                    .buttonStyle(ScaleButtonStyle())
                    .disabled(filled)
                }
            }
            .padding(.horizontal)

            Text("Score: \(score) · Round \(round + 1)")
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
