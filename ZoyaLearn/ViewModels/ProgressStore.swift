//
//  ProgressStore.swift
//  ZoyaLearn
//

import Foundation
import SwiftUI

enum MasteryLevel: String, Codable {
    case notSeen
    case inProgress
    case mastered
}

struct CharacterProgress: Codable, Equatable {
    var seen: Bool = false
    var practiced: Bool = false
    var mastered: Bool = false
}

@MainActor
final class ProgressStore: ObservableObject {
    private static let progressKey = "zoyalearn.characterProgress"
    private static let starsKey = "zoyalearn.totalStars"
    private static let badgesKey = "zoyalearn.unlockedBadges"
    private static let streakKey = "zoyalearn.streak"
    private static let lastPracticeKey = "zoyalearn.lastPracticeDate"
    private static let practiceDaysKey = "zoyalearn.practiceDays"
    private static let sessionSecondsKey = "zoyalearn.totalSessionSeconds"
    private static let flashcardStreakKey = "zoyalearn.flashcardStreak"
    private static let phonicsProgressKey = "zoyalearn.phonicsProgress"

    @Published private(set) var progressByCharacter: [String: CharacterProgress] = [:]
    @Published private(set) var phonicsProgressByWord: [String: CharacterProgress] = [:]
    @Published private(set) var totalStars: Int = 0
    @Published private(set) var unlockedBadgeIDs: Set<String> = []
    @Published private(set) var currentStreak: Int = 0
    @Published private(set) var practiceDayKeys: Set<String> = []
    @Published private(set) var totalSessionSeconds: Int = 0
    @Published var flashcardStreak: Int = 0
    @Published var newlyUnlockedBadge: Badge?

    private var sessionStart: Date?

    init() { load() }

    func beginSession() {
        sessionStart = Date()
    }

    func endSession() {
        guard let start = sessionStart else { return }
        totalSessionSeconds += max(0, Int(Date().timeIntervalSince(start)))
        sessionStart = nil
        save()
    }

    func progress(for character: String) -> CharacterProgress {
        progressByCharacter[character] ?? CharacterProgress()
    }

    func masteryLevel(for character: String) -> MasteryLevel {
        let p = progress(for: character)
        if p.mastered { return .mastered }
        if p.seen || p.practiced { return .inProgress }
        return .notSeen
    }

    func markSeen(_ character: String) {
        var p = progress(for: character)
        p.seen = true
        progressByCharacter[character] = p
        touchPracticeDay()
        save()
    }

    func markPracticed(_ character: String) {
        var p = progress(for: character)
        p.seen = true
        p.practiced = true
        progressByCharacter[character] = p
        touchPracticeDay()
        save()
    }

    func markMastered(_ character: String) {
        var p = progress(for: character)
        p.seen = true
        p.practiced = true
        p.mastered = true
        progressByCharacter[character] = p
        touchPracticeDay()
        save()
    }

    func markStillLearning(_ character: String) {
        var p = progress(for: character)
        p.seen = true
        p.practiced = true
        p.mastered = false
        progressByCharacter[character] = p
        flashcardStreak = 0
        save()
    }

    func phonicsProgress(for word: String) -> CharacterProgress {
        phonicsProgressByWord[word.lowercased()] ?? CharacterProgress()
    }

    func markPhonicsSeen(_ word: String) {
        var p = phonicsProgress(for: word)
        p.seen = true
        phonicsProgressByWord[word.lowercased()] = p
        touchPracticeDay()
        save()
    }

    func markPhonicsPracticed(_ word: String) {
        var p = phonicsProgress(for: word)
        p.seen = true
        p.practiced = true
        phonicsProgressByWord[word.lowercased()] = p
        touchPracticeDay()
        save()
    }

    func markPhonicsMastered(_ word: String) {
        var p = phonicsProgress(for: word)
        p.seen = true
        p.practiced = true
        p.mastered = true
        phonicsProgressByWord[word.lowercased()] = p
        touchPracticeDay()
        save()
    }

    var phonicsMasteryPercent: Double {
        let words = PhonicsWordData.all.map(\.word)
        guard !words.isEmpty else { return 0 }
        let mastered = words.filter { phonicsProgress(for: $0).mastered }.count
        return Double(mastered) / Double(words.count) * 100
    }

    func addStars(_ count: Int, reason: String = "") {
        guard count > 0 else { return }
        totalStars += count
        checkBadges()
        save()
    }

    func recordFlashcardKnown() {
        flashcardStreak += 1
        addStars(1)
        save()
    }

    func recordFlashcardLearning() {
        flashcardStreak = 0
        save()
    }

    var masteredCharacters: Set<String> {
        Set(progressByCharacter.filter { $0.value.mastered }.map(\.key))
    }

    var letterMasteryPercent: Double {
        percentMastered(in: LearningItemData.letters.map(\.character))
    }

    var numberMasteryPercent: Double {
        percentMastered(in: LearningItemData.numbers.map(\.character))
    }

    private func percentMastered(in characters: [String]) -> Double {
        guard !characters.isEmpty else { return 0 }
        let mastered = characters.filter { progress(for: $0).mastered }.count
        return Double(mastered) / Double(characters.count)
    }

    func resetAllProgress() {
        progressByCharacter = [:]
        phonicsProgressByWord = [:]
        totalStars = 0
        unlockedBadgeIDs = []
        currentStreak = 0
        practiceDayKeys = []
        totalSessionSeconds = 0
        flashcardStreak = 0
        newlyUnlockedBadge = nil
        save()
    }

    private func checkBadges() {
        for badge in BadgeCatalog.all where totalStars >= badge.starsRequired && !unlockedBadgeIDs.contains(badge.id) {
            unlockedBadgeIDs.insert(badge.id)
            newlyUnlockedBadge = badge
        }
    }

    func clearNewBadgeAlert() {
        newlyUnlockedBadge = nil
    }

    private func touchPracticeDay() {
        let key = Self.dayKey(for: Date())
        practiceDayKeys.insert(key)
        updateStreak()
    }

    private func updateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let todayKey = Self.dayKey(for: today)
        let yesterdayKey = Self.dayKey(for: yesterday)
        if practiceDayKeys.contains(todayKey) && practiceDayKeys.contains(yesterdayKey) {
            currentStreak = max(currentStreak, 2)
        } else if practiceDayKeys.contains(todayKey) {
            currentStreak = max(currentStreak, 1)
        }
    }

    private static func dayKey(for date: Date) -> String {
        let c = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return "\(c.year ?? 0)-\(c.month ?? 0)-\(c.day ?? 0)"
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: Self.progressKey),
           let decoded = try? JSONDecoder().decode([String: CharacterProgress].self, from: data) {
            progressByCharacter = decoded
        }
        totalStars = UserDefaults.standard.integer(forKey: Self.starsKey)
        if let badges = UserDefaults.standard.stringArray(forKey: Self.badgesKey) {
            unlockedBadgeIDs = Set(badges)
        }
        currentStreak = UserDefaults.standard.integer(forKey: Self.streakKey)
        if let days = UserDefaults.standard.stringArray(forKey: Self.practiceDaysKey) {
            practiceDayKeys = Set(days)
        }
        totalSessionSeconds = UserDefaults.standard.integer(forKey: Self.sessionSecondsKey)
        flashcardStreak = UserDefaults.standard.integer(forKey: Self.flashcardStreakKey)
        if let data = UserDefaults.standard.data(forKey: Self.phonicsProgressKey),
           let decoded = try? JSONDecoder().decode([String: CharacterProgress].self, from: data) {
            phonicsProgressByWord = decoded
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(progressByCharacter) {
            UserDefaults.standard.set(data, forKey: Self.progressKey)
        }
        if let data = try? JSONEncoder().encode(phonicsProgressByWord) {
            UserDefaults.standard.set(data, forKey: Self.phonicsProgressKey)
        }
        UserDefaults.standard.set(totalStars, forKey: Self.starsKey)
        UserDefaults.standard.set(Array(unlockedBadgeIDs), forKey: Self.badgesKey)
        UserDefaults.standard.set(currentStreak, forKey: Self.streakKey)
        UserDefaults.standard.set(Array(practiceDayKeys), forKey: Self.practiceDaysKey)
        UserDefaults.standard.set(totalSessionSeconds, forKey: Self.sessionSecondsKey)
        UserDefaults.standard.set(flashcardStreak, forKey: Self.flashcardStreakKey)
    }
}
