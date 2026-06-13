//
//  PhonicsWord.swift
//  ZoyaLearn
//

import Foundation

enum PhonicsLength: String, CaseIterable, Identifiable {
    case twoLetter = "2-Letter"
    case threeLetter = "3-Letter"
    case all = "All"

    var id: String { rawValue }
}

enum WordLength: String, Codable {
    case twoLetter
    case threeLetter
}

struct PhonicsWord: Identifiable, Hashable, Codable {
    var id: String { word.lowercased() }
    let word: String
    let emoji: String
    let hint: String
    let wordFamily: String
    let length: WordLength

    var letterParts: [String] {
        word.lowercased().map { String($0) }
    }

    var displayFamily: String {
        "-\(wordFamily)"
    }
}

struct WordFamilyInfo: Identifiable, Hashable {
    var id: String { suffix }
    let suffix: String
    let words: [PhonicsWord]

    var displayName: String { "-\(suffix)" }

    var sampleLabel: String {
        words.prefix(3).map(\.word).joined(separator: ", ")
    }
}

extension PhonicsWord {
    static func filtered(_ items: [PhonicsWord], length: PhonicsLength, family: String?) -> [PhonicsWord] {
        var result = filtered(items, by: length)
        if let family {
            result = result.filter { $0.wordFamily == family }
        }
        return result.sorted { lhs, rhs in
            if lhs.wordFamily == rhs.wordFamily {
                return lhs.word.count == rhs.word.count
                    ? lhs.word < rhs.word
                    : lhs.word.count < rhs.word.count
            }
            return lhs.wordFamily < rhs.wordFamily
        }
    }

    static func filtered(_ items: [PhonicsWord], by filter: PhonicsLength) -> [PhonicsWord] {
        switch filter {
        case .twoLetter: return items.filter { $0.length == .twoLetter }
        case .threeLetter: return items.filter { $0.length == .threeLetter }
        case .all: return items
        }
    }

    func rhymes(with other: PhonicsWord) -> Bool {
        wordFamily == other.wordFamily && word.lowercased() != other.word.lowercased()
    }
}
