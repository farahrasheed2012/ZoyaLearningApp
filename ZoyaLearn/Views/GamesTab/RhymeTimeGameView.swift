//
//  RhymeTimeGameView.swift
//  ZoyaLearn
//

import SwiftUI

struct RhymeTimeGameView: View {
    @EnvironmentObject var progressStore: ProgressStore
    @State private var round = 0
    @State private var score = 0
    @State private var target = PhonicsWordData.threeLetter.randomElement()!
    @State private var correctRhyme: PhonicsWord?
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

                VStack(spacing: 12) {
                    Text("Which word rhymes with")
                        .font(ZLTheme.Game.subtitle)
                    HStack(spacing: 12) {
                        Text(target.emoji)
                            .font(ZLTheme.Game.optionEmoji)
                        Text(target.word.uppercased())
                            .font(ZLTheme.Game.prompt)
                            .foregroundStyle(ZLTheme.accent(for: target.word))
                    }
                }

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(options) { option in
                        Button {
                            pick(option)
                        } label: {
                            VStack(spacing: 8) {
                                Text(option.emoji)
                                    .font(ZLTheme.Game.optionEmoji)
                                Text(option.word.uppercased())
                                    .font(ZLTheme.Game.optionWord)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
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
        .navigationTitle("Rhyme Time")
        .inlineNavTitle()
        .onAppear { newRound() }
    }

    private var finishView: some View {
        VStack(spacing: 20) {
            Image(systemName: "music.note.list")
                .font(.system(size: 72))
                .foregroundStyle(.purple)
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
        if option.word.lowercased() == correctRhyme?.word.lowercased() {
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
            newRound()
        }
    }

    private func newRound() {
        optionPicked = false
        let candidates = PhonicsWordData.threeLetter.filter { PhonicsWordData.randomRhyme(for: $0) != nil }
        target = candidates.randomElement() ?? PhonicsWordData.threeLetter[0]
        correctRhyme = PhonicsWordData.randomRhyme(for: target)
        var opts: [PhonicsWord] = []
        if let rhyme = correctRhyme { opts.append(rhyme) }
        let distractors = PhonicsWordData.randomDistractors(excluding: target, count: 6)
            .filter { $0.wordFamily != target.wordFamily && $0.word.lowercased() != correctRhyme?.word.lowercased() }
        opts.append(contentsOf: distractors.prefix(3))
        while opts.count < 4 {
            if let extra = PhonicsWordData.all.first(where: { w in !opts.contains(where: { $0.word == w.word }) && w.word != target.word }) {
                opts.append(extra)
            } else { break }
        }
        options = opts.shuffled()
    }

    private func restart() {
        round = 0
        score = 0
        finished = false
        newRound()
    }
}
