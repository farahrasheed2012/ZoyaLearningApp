//
//  MatchItGameView.swift
//  ZoyaLearn
//

import SwiftUI

struct MatchItGameView: View {
    @EnvironmentObject var progressStore: ProgressStore
    @State private var round = 0
    @State private var score = 0
    @State private var item = LearningItemData.all.randomElement()!
    @State private var options: [LearningItem] = []
    @State private var shakeWrong = false
    @State private var bounceCorrect = false
    @State private var finished = false

    private let totalRounds = 10

    var body: some View {
        VStack(spacing: 24) {
            if finished {
                VStack(spacing: 16) {
                    Text("Round complete!")
                        .font(.largeTitle.bold())
                    Text("Score: \(score)/\(totalRounds)")
                        .font(.title2)
                    Button("Play again") { restart() }
                        .buttonStyle(.borderedProminent)
                }
            } else {
                Text("Question \(round + 1) of \(totalRounds)")
                    .foregroundStyle(.secondary)
                Text("Which goes with \(item.character)?")
                    .font(.title2.bold())
                Text(item.exampleEmoji)
                    .font(.system(size: 64))

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(options) { option in
                        Button {
                            pick(option)
                        } label: {
                            VStack {
                                Text(option.exampleEmoji).font(.largeTitle)
                                Text(option.exampleWord).font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 16).fill(.background))
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
                .padding(.horizontal)
                .offset(x: shakeWrong ? -8 : 0)
                .scaleEffect(bounceCorrect ? 1.04 : 1)
            }
            Spacer()
        }
        .padding(.top, 24)
        .navigationTitle("Match It")
        .inlineNavTitle()
        .onAppear { newRound() }
    }

    private func pick(_ option: LearningItem) {
        if option.character == item.character {
            score += 1
            progressStore.addStars(1)
            HapticManager.success()
            withAnimation(.spring) { bounceCorrect = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                bounceCorrect = false
                advance()
            }
        } else {
            HapticManager.error()
            withAnimation(.default.repeatCount(3, autoreverses: true)) { shakeWrong = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { shakeWrong = false }
        }
    }

    private func advance() {
        round += 1
        if round >= totalRounds {
            finished = true
        } else {
            newRound()
        }
    }

    private func newRound() {
        item = LearningItemData.all.randomElement()!
        var opts = [item]
        opts.append(contentsOf: LearningItemData.all.filter { $0.character != item.character }.shuffled().prefix(3))
        options = opts.shuffled()
    }

    private func restart() {
        round = 0
        score = 0
        finished = false
        newRound()
    }
}
