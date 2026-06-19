//
//  ParentDashboardViewModel.swift
//  ZoyaLearn
//

import Foundation

struct CharacterMasteryRow: Identifiable {
    var id: String { character }
    let character: String
    let type: ItemType
    let level: MasteryLevel
}

@MainActor
final class ParentDashboardViewModel: ObservableObject {
    let progressStore: ProgressStore

    init(progressStore: ProgressStore) {
        self.progressStore = progressStore
    }

    var totalMinutes: Int {
        progressStore.totalSessionSeconds / 60
    }

    var masteryRows: [CharacterMasteryRow] {
        LearningItemData.all.map { item in
            CharacterMasteryRow(
                character: item.character,
                type: item.type,
                level: progressStore.masteryLevel(for: item.character)
            )
        }
    }

    var practiceDayKeys: [String] {
        progressStore.practiceDayKeys.sorted()
    }

    var weeklyLetterPlan: [LearningItem] {
        TodaysLessonPlanner.make(progressStore: progressStore).weekLetters
    }

    var weeklyPlanSummary: String {
        weeklyLetterPlan.map { letter in
            let level = progressStore.masteryLevel(for: letter.character)
            return "\(letter.displayPair) — \(letter.exampleWord) (\(level.rawValue))"
        }.joined(separator: "\n")
    }

    func exportSummary() -> String {
        var lines: [String] = ["ZoyaLearn Progress Summary", "Generated: \(Date().formatted())", ""]
        lines.append("Total stars: \(progressStore.totalStars)")
        lines.append("Time spent: \(totalMinutes) minutes")
        lines.append("Current streak: \(progressStore.currentStreak) days")
        lines.append("")
        lines.append("This week's letter focus:")
        for item in weeklyLetterPlan {
            let level = progressStore.masteryLevel(for: item.character)
            lines.append("\(item.displayPair) — \(item.exampleWord): \(level.rawValue)")
        }
        lines.append("")
        lines.append("Character mastery:")
        for row in masteryRows {
            lines.append("\(row.character) (\(row.type.rawValue)): \(row.level.rawValue)")
        }
        return lines.joined(separator: "\n")
    }
}
