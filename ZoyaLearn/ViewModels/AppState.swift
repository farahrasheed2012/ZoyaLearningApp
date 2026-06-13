//
//  AppState.swift
//  ZoyaLearn
//

import Foundation

enum AppTab: String, CaseIterable, Identifiable {
    case learn, trace, flashcards, games, progress

    var id: String { rawValue }

    var title: String {
        switch self {
        case .learn: return "Learn"
        case .trace: return "Trace"
        case .flashcards: return "Flashcards"
        case .games: return "Games"
        case .progress: return "Progress"
        }
    }

    var systemImage: String {
        switch self {
        case .learn: return "book.fill"
        case .trace: return "pencil.tip"
        case .flashcards: return "rectangle.stack.fill"
        case .games: return "gamecontroller.fill"
        case .progress: return "star.fill"
        }
    }
}

@MainActor
final class AppState: ObservableObject {
    @Published var selectedTab: AppTab = .learn
    @Published var todaysLetter: LearningItem?

    func refreshTodaysLetter(progressStore: ProgressStore) {
        todaysLetter = LearningItemData.randomUnmastered(from: LearningItemData.all, mastered: progressStore.masteredCharacters)
    }

    func showTodaysLetter(progressStore: ProgressStore) {
        refreshTodaysLetter(progressStore: progressStore)
        selectedTab = .learn
        if let item = todaysLetter {
            NotificationCenter.default.post(name: .zlJumpToCharacter, object: item.character)
        }
    }
}
