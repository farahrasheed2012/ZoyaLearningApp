//
//  GamesHubView.swift
//  ZoyaLearn
//

import SwiftUI

enum GameCategory: String, CaseIterable {
    case letters = "Letter Games"
    case phonics = "Phonics Games"
}

enum MiniGame: String, CaseIterable, Identifiable {
    case matchIt, findIt, fillBlank, memoryMatch
    case soundMatch, spellIt, rhymeTime

    var id: String { rawValue }

    var category: GameCategory {
        switch self {
        case .matchIt, .findIt, .fillBlank, .memoryMatch: return .letters
        case .soundMatch, .spellIt, .rhymeTime: return .phonics
        }
    }

    var title: String {
        switch self {
        case .matchIt: return "Match It"
        case .findIt: return "Find It"
        case .fillBlank: return "Fill in the Blank"
        case .memoryMatch: return "Memory Match"
        case .soundMatch: return "Sound Match"
        case .spellIt: return "Spell It"
        case .rhymeTime: return "Rhyme Time"
        }
    }

    var subtitle: String {
        switch self {
        case .matchIt: return "Pick the picture that matches the letter"
        case .findIt: return "Tap every matching letter before time runs out"
        case .fillBlank: return "Choose the missing letter in the sequence"
        case .memoryMatch: return "Flip cards to match letters and pictures"
        case .soundMatch: return "Listen and pick the right word"
        case .spellIt: return "Tap letters to spell the word you see"
        case .rhymeTime: return "Find the word that rhymes"
        }
    }

    var systemImage: String {
        switch self {
        case .matchIt: return "puzzlepiece.extension.fill"
        case .findIt: return "hand.tap.fill"
        case .fillBlank: return "character.textbox"
        case .memoryMatch: return "square.grid.3x3.fill"
        case .soundMatch: return "ear.fill"
        case .spellIt: return "pencil.and.outline"
        case .rhymeTime: return "music.note.list"
        }
    }

    var tint: Color {
        switch self {
        case .matchIt: return ZLTheme.accentColors[4]
        case .findIt: return ZLTheme.accentColors[1]
        case .fillBlank: return ZLTheme.accentColors[5]
        case .memoryMatch: return ZLTheme.accentColors[2]
        case .soundMatch: return ZLTheme.accentColors[6]
        case .spellIt: return ZLTheme.accentColors[3]
        case .rhymeTime: return ZLTheme.accentColors[0]
        }
    }

    @ViewBuilder
    var destination: some View {
        switch self {
        case .matchIt: MatchItGameView()
        case .findIt: FindItGameView()
        case .fillBlank: FillBlankGameView()
        case .memoryMatch: MemoryMatchGameView()
        case .soundMatch: SoundMatchGameView()
        case .spellIt: SpellItGameView()
        case .rhymeTime: RhymeTimeGameView()
        }
    }
}

struct GamesHubView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ForEach(GameCategory.allCases, id: \.self) { category in
                    VStack(alignment: .leading, spacing: 12) {
                        Label(category.rawValue, systemImage: category == .letters ? "textformat.abc" : "text.book.closed.fill")
                            .font(.title3.bold())
                            .padding(.horizontal, 4)

                        ForEach(MiniGame.allCases.filter { $0.category == category }) { game in
                            NavigationLink {
                                game.destination
                            } label: {
                                GameHubCard(game: game)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding()
        }
        .background(ZLPlatformColor.groupedBackground)
        .navigationTitle("Games")
        .largeNavTitle()
    }
}

private struct GameHubCard: View {
    let game: MiniGame

    var body: some View {
        HStack(spacing: 18) {
            Image(systemName: game.systemImage)
                .font(.system(size: 32, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 64, height: 64)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(game.tint.gradient)
                )
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 6) {
                Text(game.title)
                    .font(.title2.bold())
                    .foregroundStyle(.primary)
                Text(game.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
            }

            Spacer(minLength: 8)

            Image(systemName: "chevron.right.circle.fill")
                .font(.title2)
                .foregroundStyle(game.tint.opacity(0.85))
                .accessibilityHidden(true)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: ZLTheme.cornerRadius)
                .fill(.background)
                .shadow(color: game.tint.opacity(0.15), radius: ZLTheme.shadowRadius, y: 4)
        )
        .accessibilityElement(children: .combine)
        .accessibilityHint("Opens \(game.title)")
    }
}
