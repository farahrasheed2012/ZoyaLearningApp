//
//  MemoryMatchGameView.swift
//  ZoyaLearn
//

import SwiftUI

private struct MemoryCard: Identifiable, Equatable {
    let id = UUID()
    let pairID: String
    let face: MemoryFace

    enum MemoryFace: Equatable {
        case letter(String)
        case picture(String, emoji: String)
    }
}

struct MemoryMatchGameView: View {
    @EnvironmentObject var progressStore: ProgressStore
    @State private var cards: [MemoryCard] = []
    @State private var flipped: Set<UUID> = []
    @State private var matched: Set<String> = []
    @State private var firstPick: UUID?
    @State private var lockInput = false
    @State private var moves = 0

    private let pairCount = 6

    var body: some View {
        VStack(spacing: 20) {
            Label("Match the letter to its picture", systemImage: "square.grid.2x2.fill")
                .font(ZLTheme.Game.subtitle)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Label("Moves: \(moves) · Pairs: \(matched.count)/\(pairCount)", systemImage: "arrow.triangle.2.circlepath")
                .font(ZLTheme.Game.progress)
                .foregroundStyle(.secondary)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                ForEach(cards) { card in
                    memoryTile(card)
                }
            }
            .padding(.horizontal)

            if matched.count == pairCount {
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

            Spacer()
        }
        .padding(.top)
        .navigationTitle("Memory Match")
        .inlineNavTitle()
        .onAppear { startGame() }
    }

    @ViewBuilder
    private func memoryTile(_ card: MemoryCard) -> some View {
        let isFaceUp = flipped.contains(card.id) || matched.contains(card.pairID)
        Button {
            tap(card)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(isFaceUp ? Color.accentColor.opacity(0.12) : Color.accentColor.opacity(0.35))
                if isFaceUp {
                    switch card.face {
                    case .letter(let char):
                        Text(char)
                            .font(ZLTheme.Game.tileCharacter)
                            .foregroundStyle(ZLTheme.accent(for: char))
                    case .picture(_, let emoji):
                        Text(emoji)
                            .font(ZLTheme.Game.optionEmoji)
                    }
                } else {
                    Image(systemName: "questionmark")
                        .font(.title.bold())
                        .foregroundStyle(.white)
                }
            }
            .frame(height: 88)
        }
        .buttonStyle(ScaleButtonStyle())
        .disabled(matched.contains(card.pairID) || lockInput)
    }

    private func tap(_ card: MemoryCard) {
        guard !flipped.contains(card.id), !matched.contains(card.pairID) else { return }

        flipped.insert(card.id)

        if let firstID = firstPick {
            moves += 1
            lockInput = true
            guard let first = cards.first(where: { $0.id == firstID }) else {
                lockInput = false
                return
            }
            if first.pairID == card.pairID {
                matched.insert(card.pairID)
                progressStore.addStars(1)
                HapticManager.success()
                firstPick = nil
                lockInput = false
                if matched.count == pairCount {
                    progressStore.addStars(3)
                }
            } else {
                HapticManager.error()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
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

    private func startGame() {
        let items = LearningItemData.all.shuffled().prefix(pairCount)
        var deck: [MemoryCard] = []
        for item in items {
            deck.append(MemoryCard(pairID: item.character, face: .letter(item.character)))
            deck.append(MemoryCard(pairID: item.character, face: .picture(item.exampleWord, emoji: item.exampleEmoji)))
        }
        cards = deck.shuffled()
        flipped = []
        matched = []
        firstPick = nil
        lockInput = false
        moves = 0
    }
}
