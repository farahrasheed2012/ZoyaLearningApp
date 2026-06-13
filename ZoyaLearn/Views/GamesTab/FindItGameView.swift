//
//  FindItGameView.swift
//  ZoyaLearn
//

import SwiftUI

struct FindItGameView: View {
    @EnvironmentObject var progressStore: ProgressStore
    @State private var target = LearningItemData.letters.randomElement()!
    @State private var tiles: [LearningItem] = []
    @State private var selected: Set<String> = []
    @State private var timeLeft: Double = 15
    @State private var timer: Timer?
    @State private var finished = false

    var body: some View {
        VStack(spacing: 20) {
            Label {
                Text("\(Int(ceil(timeLeft))) seconds left")
                    .font(ZLTheme.Game.progress)
            } icon: {
                Image(systemName: "timer")
            }
            .foregroundStyle(.secondary)
            .padding(.horizontal)

            ProgressView(value: timeLeft, total: 15)
                .padding(.horizontal)
                .accessibilityLabel("Time remaining")

            Label {
                Text("Tap all the \(target.character)'s!")
                    .font(ZLTheme.Game.prompt)
                    .multilineTextAlignment(.center)
            } icon: {
                Image(systemName: "hand.tap.fill")
                    .font(.title)
                    .foregroundStyle(Color.accentColor)
            }
            .labelStyle(.titleAndIcon)
            .padding(.horizontal)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
                ForEach(tiles) { tile in
                    let isTarget = tile.character == target.character
                    let isSelected = selected.contains(tile.id)
                    Button {
                        tap(tile, isTarget: isTarget)
                    } label: {
                        Text(tile.character)
                            .font(ZLTheme.Game.tileCharacter)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 22)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(isSelected ? (isTarget ? Color.green.opacity(0.35) : Color.red.opacity(0.25)) : ZLPlatformColor.cardBackground)
                            )
                    }
                    .buttonStyle(ScaleButtonStyle())
                    .disabled(isSelected || finished)
                }
            }
            .padding(.horizontal)

            if finished {
                Label("Great finding!", systemImage: "checkmark.seal.fill")
                    .font(ZLTheme.Game.subtitle)
                    .foregroundStyle(.green)
                Button {
                    startGame()
                } label: {
                    Label("Play again", systemImage: "arrow.clockwise")
                        .font(ZLTheme.Game.progress)
                }
                .buttonStyle(.borderedProminent)
            }

            Spacer()
        }
        .padding(.top)
        .navigationTitle("Find It")
        .inlineNavTitle()
        .onAppear { startGame() }
        .onDisappear { timer?.invalidate() }
    }

    private func startGame() {
        timer?.invalidate()
        target = LearningItemData.all.randomElement()!
        selected = []
        timeLeft = 15
        finished = false
        var pool = Array(repeating: target, count: 4)
        pool.append(contentsOf: LearningItemData.all.filter { $0.character != target.character }.shuffled().prefix(8))
        tiles = pool.shuffled()
        SpeechManager.shared.speakPrompt("Tap all the \(target.character)'s!")
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            Task { @MainActor in
                timeLeft -= 0.1
                if timeLeft <= 0 {
                    timer?.invalidate()
                    finished = true
                }
            }
        }
    }

    private func tap(_ tile: LearningItem, isTarget: Bool) {
        selected.insert(tile.id)
        if isTarget {
            progressStore.addStars(1)
            HapticManager.lightImpact()
            if selected.filter({ id in tiles.first(where: { $0.id == id })?.character == target.character }).count >= 4 {
                timer?.invalidate()
                finished = true
                progressStore.addStars(3)
                SpeechManager.shared.speakPraise()
            }
        } else {
            HapticManager.error()
        }
    }
}
