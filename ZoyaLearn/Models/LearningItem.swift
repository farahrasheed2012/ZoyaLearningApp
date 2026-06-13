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
    let phonetic: String
    let funFact: String
}

enum ContentFilter: String, CaseIterable, Identifiable {
    case letters = "Letters"
    case numbers = "Numbers"
    case all = "All"

    var id: String { rawValue }
}

extension LearningItem {
    static func filtered(_ items: [LearningItem], by filter: ContentFilter) -> [LearningItem] {
        switch filter {
        case .letters: return items.filter { $0.type == .letter }
        case .numbers: return items.filter { $0.type == .number }
        case .all: return items
        }
    }
}
