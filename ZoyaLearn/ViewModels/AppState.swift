//
//  AppState.swift
//  ZoyaLearn
//

import Foundation

enum AppTab: String, CaseIterable, Identifiable {
    case learn, phonics, trace, flashcards, games, progress

    var id: String { rawValue }

    var title: String {
        switch self {
        case .learn: return "Learn"
        case .phonics: return "Phonics"
        case .trace: return "Trace"
        case .flashcards: return "Flashcards"
        case .games: return "Games"
        case .progress: return "Progress"
        }
    }

    var systemImage: String {
        switch self {
        case .learn: return "book.fill"
        case .phonics: return "text.book.closed.fill"
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
    @Published var todaysLesson: TodaysLesson?
    @Published var lessonFocusCharacter: String?
    @Published var pendingLessonDestination: MapLocation?

    func refreshTodaysLesson(progressStore: ProgressStore) {
        todaysLesson = TodaysLessonPlanner.make(progressStore: progressStore)
        todaysLetter = todaysLesson?.letter
    }

    func beginLessonStep(_ step: LessonStep) {
        guard let lesson = todaysLesson else { return }
        lessonFocusCharacter = lesson.letter.character
        pendingLessonDestination = step.mapLocation
    }

    func clearLessonNavigation() {
        pendingLessonDestination = nil
    }

    func refreshTodaysLetter(progressStore: ProgressStore) {
        refreshTodaysLesson(progressStore: progressStore)
    }

    func showTodaysLetter(progressStore: ProgressStore) {
        refreshTodaysLesson(progressStore: progressStore)
        selectedTab = .learn
        if let item = todaysLetter {
            NotificationCenter.default.post(name: .zlJumpToCharacter, object: item.character)
        }
    }
}
