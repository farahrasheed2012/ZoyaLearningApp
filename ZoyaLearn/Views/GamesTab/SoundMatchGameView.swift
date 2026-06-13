//
//  SoundMatchGameView.swift
//  ZoyaLearn
//

import SwiftUI

struct SoundMatchGameView: View {
    @EnvironmentObject var progressStore: ProgressStore
    @State private var round = 0
    @State private var score = 0
    @State private var target = PhonicsWordData.all.randomElement()!
    @State private var options: [PhonicsWord] = []
    @State private var finished = false
    @State private var shakeWrong = false
    @State private var optionPicked = false

    private let totalRounds = 10

    var body: some View {
        VStack(spacing: 28) {
            if finished {
                finishView
            } else {
                Label("Question \(round + 1) of \(totalRounds)", systemImage: "list.number")
                    .font(ZLTheme.Game.progress)
                    .foregroundStyle(.secondary)

                Label("Which word do you hear?", systemImage: "ear.fill")
                    .font(ZLTheme.Game.prompt)
                    .multilineTextAlignment(.center)

                Button {
                    SpeechManager.shared.speakWord(target)
                } label: {
                    Label("Play sound", systemImage: "speaker.wave.3.fill")
                        .font(ZLTheme.Game.subtitle)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .background(Capsule().fill(Color.accentColor.opacity(0.18)))
                }
                .buttonStyle(ScaleButtonStyle())

                VStack(spacing: 14) {
                    ForEach(options) { option in
                        Button {
                            pick(option)
                        } label: {
                            HStack(spacing: 14) {
                                Text(option.emoji)
                                    .font(ZLTheme.Game.optionEmoji)
                                Text(option.word.uppercased())
                                    .font(ZLTheme.Game.optionWord)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(RoundedRectangle(cornerRadius: 16).fill(.background))
                        }
                        .buttonStyle(ScaleButtonStyle())
                        .disabled(optionPicked)
                    }
                }
                .padding(.horizontal)
                .offset(x: shakeWrong ? -8 : 0)
            }
            Spacer()
        }
        .padding(.top, 24)
        .navigationTitle("Sound Match")
        .inlineNavTitle()
        .onAppear { newRound(playSound: true) }
    }

    private var finishView: some View {
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
    }

    private func pick(_ option: PhonicsWord) {
        if option.word.lowercased() == target.word.lowercased() {
            optionPicked = true
            score += 1
            progressStore.addStars(1)
            HapticManager.success()
            advance()
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
            newRound(playSound: true)
        }
    }

    private func newRound(playSound: Bool) {
        optionPicked = false
        target = PhonicsWordData.all.randomElement()!
        var opts = [target]
        opts.append(contentsOf: PhonicsWordData.randomDistractors(excluding: target, count: 3))
        options = opts.shuffled()
        if playSound {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                SpeechManager.shared.speakWord(target)
            }
        }
    }

    private func restart() {
        round = 0
        score = 0
        finished = false
        newRound(playSound: true)
    }
}
