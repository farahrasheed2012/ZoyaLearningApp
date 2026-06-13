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
        VStack(spacing: 16) {
            ProgressView(value: timeLeft, total: 15)
                .padding(.horizontal)
                .accessibilityLabel("Time remaining")

            Text("Tap all the \(target.character)'s!")
                .font(.title2.bold())

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4), spacing: 10) {
                ForEach(tiles) { tile in
                    let isTarget = tile.character == target.character
                    let isSelected = selected.contains(tile.id)
                    Button {
                        tap(tile, isTarget: isTarget)
                    } label: {
                        Text(tile.character)
                            .font(.title.bold())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(isSelected ? (isTarget ? Color.green.opacity(0.35) : Color.red.opacity(0.25)) : ZLPlatformColor.cardBackground)
                            )
                    }
                    .buttonStyle(ScaleButtonStyle())
                    .disabled(isSelected || finished)
                }
            }
            .padding(.horizontal)

            if finished {
                Text("Great finding!")
                    .font(.headline)
                Button("Play again") { startGame() }
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
