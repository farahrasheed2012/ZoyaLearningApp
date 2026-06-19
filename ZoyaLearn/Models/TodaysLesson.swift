//
//  TodaysLesson.swift
//  ZoyaLearn
//

import Foundation

struct TodaysLesson: Equatable {
    let letter: LearningItem
    let weekLetters: [LearningItem]

    var title: String {
        "\(letter.character) for \(letter.exampleWord) \(letter.exampleEmoji)"
    }

    @MainActor
    func stepDone(_ step: LessonStep, progressStore: ProgressStore) -> Bool {
        let p = progressStore.progress(for: letter.character)
        switch step {
        case .explore: return p.seen
        case .trace: return p.practiced
        case .read: return p.seen
        case .play: return p.quizPassed || p.practiced
        case .quiz: return p.quizPassed
        case .mastered: return p.mastered
        }
    }
}

enum LessonStep: String, CaseIterable, Identifiable {
    case explore = "Meet the letter"
    case trace = "Trace it"
    case read = "Read the book"
    case play = "Play a game"
    case quiz = "Letter quiz"
    case mastered = "Mastered!"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .explore: return "house.fill"
        case .trace: return "pencil.tip"
        case .read: return "book.fill"
        case .play: return "gamecontroller.fill"
        case .quiz: return "questionmark.circle.fill"
        case .mastered: return "star.fill"
        }
    }

    var mapLocation: MapLocation? {
        switch self {
        case .explore: return .letterHouse
        case .trace: return .artCorner
        case .read: return .libraryTree
        case .play: return .backyard
        case .quiz, .mastered: return .letterHouse
        }
    }
}

enum TodaysLessonPlanner {
    /// Picks the first unmastered letter in A–Z order, or rotates by weekday if all done.
    @MainActor
    static func make(progressStore: ProgressStore) -> TodaysLesson {
        let letters = LearningItemData.letters
        let focus = letters.first { !progressStore.progress(for: $0.character).mastered }
            ?? letters[Calendar.current.component(.weekday, from: Date()) % letters.count]

        let startIndex = letters.firstIndex(where: { $0.character == focus.character }) ?? 0
        let weekLetters = (0..<3).map { letters[(startIndex + $0) % letters.count] }

        return TodaysLesson(letter: focus, weekLetters: weekLetters)
    }
}
