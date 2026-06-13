//
//  MemoryMatchGameView.swift
//  ZoyaLearn
//

import SwiftUI

enum MemoryGridSize: String, CaseIterable, Identifiable {
    case small = "2×2"
    case medium = "3×4"
    case large = "4×4"
    case extraLarge = "4×5"

    var id: String { rawValue }

    var columns: Int {
        switch self {
        case .small: return 2
        case .medium: return 4
        case .large, .extraLarge: return 4
        }
    }

    var pairCount: Int {
        switch self {
        case .small: return 2
        case .medium: return 6
        case .large: return 8
        case .extraLarge: return 10
        }
    }

    var tileHeight: CGFloat {
        switch self {
        case .small: return 100
        case .medium: return 88
        case .large: return 78
        case .extraLarge: return 72
        }
    }
}

private struct MemoryCard: Identifiable {
    let id = UUID()
    let pairID: String
    let glyph: String
    let word: String
    let emoji: String
    let isEmojiFace: Bool
}

struct MemoryMatchGameView: View {
    @EnvironmentObject var progressStore: ProgressStore
    @State private var gridSize: MemoryGridSize = .medium
    @State private var cards: [MemoryCard] = []
    @State private var flipped: Set<UUID> = []
    @State private var matched: Set<String> = []
    @State private var firstPick: UUID?
    @State private var lockInput = false
    @State private var moves = 0
    @State private var lastMatchedLabel: String?
    @State private var gameStarted = false

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                settingsBar

                Label("Match letters & numbers to their pictures", systemImage: "square.grid.2x2.fill")
                    .font(ZLTheme.Game.subtitle)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Label("Moves: \(moves) · Pairs: \(matched.count)/\(gridSize.pairCount)", systemImage: "arrow.triangle.2.circlepath")
                    .font(ZLTheme.Game.progress)
                    .foregroundStyle(.secondary)

                if let lastMatchedLabel {
                    Text(lastMatchedLabel)
                        .font(ZLTheme.Game.progress)
                        .foregroundStyle(.green)
                }

                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: gridSize.columns),
                    spacing: 10
                ) {
                    ForEach(cards) { card in
                        memoryTile(card)
                    }
                }
                .padding(.horizontal)

                if matched.count == gridSize.pairCount {
                    Label("You matched them all!", systemImage: "party.popper.fill")
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
            }
            .padding(.vertical)
        }
        .navigationTitle("Memory Match")
        .inlineNavTitle()
        .onAppear {
            if !gameStarted { startGame() }
        }
    }

    private var settingsBar: some View {
        VStack(spacing: 12) {
            Picker("Grid size", selection: $gridSize) {
                ForEach(MemoryGridSize.allCases) { size in
                    Text(size.rawValue).tag(size)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .onChange(of: gridSize) { _, _ in
                startGame()
            }

            Text("\(gridSize.rawValue) grid · \(gridSize.pairCount) pairs · letters, numbers & emojis")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }

    @ViewBuilder
    private func memoryTile(_ card: MemoryCard) -> some View {
        let isFaceUp = flipped.contains(card.id) || matched.contains(card.pairID)
        let isMatched = matched.contains(card.pairID)

        Button {
            tap(card)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(isFaceUp ? Color.accentColor.opacity(0.12) : Color.accentColor.opacity(0.35))
                    .overlay {
                        if isMatched {
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.green.opacity(0.55), lineWidth: 2)
                        }
                    }

                if isFaceUp {
                    VStack(spacing: 6) {
                        if card.isEmojiFace {
                            Text(card.emoji)
                                .font(ZLTheme.Game.optionEmoji)
                        } else {
                            Text(card.glyph)
                                .font(ZLTheme.Game.tileCharacter)
                                .foregroundStyle(ZLTheme.accent(for: card.glyph))
                        }

                        if isMatched {
                            HStack(spacing: 4) {
                                Text(card.glyph)
                                    .font(.caption.weight(.bold))
                                Text("·")
                                Text(card.isEmojiFace ? card.emoji : card.word)
                                    .font(.caption)
                            }
                            .foregroundStyle(ZLTheme.accent(for: card.glyph))
                        }
                    }
                } else {
                    Image(systemName: "questionmark")
                        .font(.title.bold())
                        .foregroundStyle(.white)
                }
            }
            .frame(height: gridSize.tileHeight)
        }
        .buttonStyle(ScaleButtonStyle())
        .disabled(isMatched || lockInput)
        .accessibilityLabel(isFaceUp
            ? (card.isEmojiFace ? "Picture \(card.word)" : "Letter or number \(card.glyph)")
            : "Hidden card")
    }

    private func tap(_ card: MemoryCard) {
        guard !matched.contains(card.pairID), !flipped.contains(card.id), !lockInput else { return }

        flipped.insert(card.id)

        if let firstID = firstPick {
            moves += 1
            lockInput = true

            guard let first = cards.first(where: { $0.id == firstID }) else {
                lockInput = false
                firstPick = nil
                return
            }

            if first.pairID == card.pairID {
                matched.insert(card.pairID)
                flipped.remove(firstID)
                flipped.remove(card.id)
                firstPick = nil
                lastMatchedLabel = matchLabel(for: card)
                progressStore.addStars(1)
                HapticManager.success()
                SpeechManager.shared.speak("\(card.glyph)... \(card.word)")
                lockInput = false

                if matched.count == gridSize.pairCount {
                    progressStore.addStars(3)
                }
            } else {
                HapticManager.error()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                    flipped.remove(firstID)
                    flipped.remove(card.id)
                    firstPick = nil
                    lockInput = false
                }
            }
        } else {
            firstPick = card.id
        }
    }

    private func matchLabel(for card: MemoryCard) -> String {
        if card.glyph.first?.isNumber == true {
            return "\(card.glyph) is \(card.word)!"
        }
        return "\(card.glyph) is for \(card.word)!"
    }

    private func startGame() {
        gameStarted = true
        let count = gridSize.pairCount
        let items = LearningItemData.all.shuffled().prefix(count)
        var deck: [MemoryCard] = []

        for item in items {
            let pairID = "\(item.type.rawValue)-\(item.character)"
            deck.append(MemoryCard(
                pairID: pairID,
                glyph: item.character,
                word: item.exampleWord,
                emoji: item.exampleEmoji,
                isEmojiFace: false
            ))
            deck.append(MemoryCard(
                pairID: pairID,
                glyph: item.character,
                word: item.exampleWord,
                emoji: item.exampleEmoji,
                isEmojiFace: true
            ))
        }

        cards = deck.shuffled()
        flipped = []
        matched = []
        firstPick = nil
        lockInput = false
        moves = 0
        lastMatchedLabel = nil
    }
}
