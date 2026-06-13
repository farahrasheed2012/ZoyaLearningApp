//
//  MatchItGameView.swift
//  ZoyaLearn
//

import SwiftUI

struct MatchItGameView: View {
    @EnvironmentObject var progressStore: ProgressStore
    @State private var round = 0
    @State private var score = 0
    @State private var item = LearningItemData.letters.randomElement()!
    @State private var options: [LearningItem] = []
    @State private var shakeWrong = false
    @State private var bounceCorrect = false
    @State private var finished = false
    @State private var optionPicked = false

    private let totalRounds = 10

    var body: some View {
        VStack(spacing: 28) {
            if finished {
                VStack(spacing: 20) {
                    Image(systemName: "star.circle.fill")
                        .font(.system(size: 72))
                        .foregroundStyle(.yellow)
                    Text("Round complete!")
                        .font(ZLTheme.Game.prompt)
                    Text("Score: \(score)/\(totalRounds)")
                        .font(ZLTheme.Game.subtitle)
                    Button {
                        restart()
                    } label: {
                        Label("Play again", systemImage: "arrow.clockwise")
                            .font(ZLTheme.Game.progress)
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else {
                Label("Question \(round + 1) of \(totalRounds)", systemImage: "list.number")
                    .font(ZLTheme.Game.progress)
                    .foregroundStyle(.secondary)

                Label {
                    Text("Which goes with \(item.character)?")
                        .font(ZLTheme.Game.prompt)
                        .multilineTextAlignment(.center)
                } icon: {
                    Image(systemName: "questionmark.circle.fill")
                        .font(.title)
                        .foregroundStyle(Color.accentColor)
                }
                .labelStyle(.titleAndIcon)

                Text(item.character)
                    .font(ZLTheme.Game.blankSlot)
                    .foregroundStyle(ZLTheme.accent(for: item.character))

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(options) { option in
                        Button {
                            pick(option)
                        } label: {
                            VStack(spacing: 10) {
                                Text(option.exampleEmoji)
                                    .font(ZLTheme.Game.optionEmoji)
                                Text(option.exampleWord)
                                    .font(ZLTheme.Game.optionWord)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .padding(.horizontal, 12)
                            .background(RoundedRectangle(cornerRadius: 16).fill(.background))
                        }
                        .buttonStyle(ScaleButtonStyle())
                        .disabled(optionPicked)
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
            optionPicked = true
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
        optionPicked = false
        item = LearningItemData.letters.randomElement()!
        var opts = [item]
        opts.append(contentsOf: LearningItemData.letters.filter { $0.character != item.character }.shuffled().prefix(3))
        options = opts.shuffled()
    }

    private func restart() {
        round = 0
        score = 0
        finished = false
        newRound()
    }
}
