//
//  LearningItem.swift
//  ZoyaLearn
//

import Foundation

enum ItemType: String, Codable, CaseIterable {
    case letter
    case number
}

struct LearningItem: Identifiable, Hashable, Codable {
    var id: String { character }
    let character: String
    let type: ItemType
    let exampleWord: String
    let exampleEmoji: String
    let illustrationName: String
    let phonetic: String
    let funFact: String

    init(
        character: String,
        type: ItemType,
        exampleWord: String,
        exampleEmoji: String,
        illustrationName: String? = nil,
        phonetic: String,
        funFact: String
    ) {
        self.character = character
        self.type = type
        self.exampleWord = exampleWord
        self.exampleEmoji = exampleEmoji
        self.illustrationName = illustrationName ?? exampleWord.lowercased()
        self.phonetic = phonetic
        self.funFact = funFact
    }
}

enum ContentFilter: String, CaseIterable, Identifiable {
    case letters = "Letters"
    case numbers = "Numbers"
    case all = "All"

    var id: String { rawValue }
}

extension LearningItem {
    /// Lowercase form for letters (e.g. "a"); numbers unchanged.
    var lowercaseCharacter: String {
        type == .letter ? character.lowercased() : character
    }

    /// Uppercase + lowercase pair for display (e.g. "Aa").
    var displayPair: String {
        type == .letter ? "\(character)\(lowercaseCharacter)" : character
    }

    /// Kid-friendly sound label shown in UI (e.g. "b").
    var soundLabel: String {
        guard type == .letter else { return phonetic }
        return PhonicsPhonemeMap.letterSound(for: character).label
    }

    /// Spoken phoneme for text-to-speech (e.g. "buh").
    var soundSpeak: String {
        guard type == .letter else { return phonetic }
        return PhonicsPhonemeMap.letterSound(for: character).speak
    }

    static func filtered(_ items: [LearningItem], by filter: ContentFilter) -> [LearningItem] {
        switch filter {
        case .letters: return items.filter { $0.type == .letter }
        case .numbers: return items.filter { $0.type == .number }
        case .all: return items
        }
    }
}
