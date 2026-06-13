//
//  PhonicsViewModel.swift
//  ZoyaLearn
//

import Foundation
import SwiftUI

@MainActor
final class PhonicsViewModel: ObservableObject {
    @Published var lengthFilter: PhonicsLength = .all
    @Published var familyFilter: String?
    @Published var currentIndex: Int = 0
    @Published var cardScale: CGFloat = 0.92
    @Published private(set) var displayOrder: [PhonicsWord] = []

    var items: [PhonicsWord] { displayOrder }

    var availableFamilies: [WordFamilyInfo] {
        let pool = PhonicsWord.filtered(PhonicsWordData.all, by: lengthFilter)
        let suffixes = Set(pool.map(\.wordFamily))
        return PhonicsWordData.families.filter { suffixes.contains($0.suffix) }
    }

    var selectedFamilyInfo: WordFamilyInfo? {
        guard let familyFilter else { return nil }
        return PhonicsWordData.families.first { $0.suffix == familyFilter }
    }

    var currentWord: PhonicsWord? {
        guard !displayOrder.isEmpty else { return nil }
        let idx = min(max(currentIndex, 0), displayOrder.count - 1)
        return displayOrder[idx]
    }

    func syncDisplayOrder(shuffled: Bool = false) {
        if let familyFilter, !availableFamilies.contains(where: { $0.suffix == familyFilter }) {
            self.familyFilter = nil
        }
        let filtered = PhonicsWord.filtered(PhonicsWordData.all, length: lengthFilter, family: familyFilter)
        displayOrder = shuffled ? filtered.shuffled() : filtered
        currentIndex = min(currentIndex, max(displayOrder.count - 1, 0))
    }

    func selectFamily(_ suffix: String?) {
        familyFilter = suffix
        currentIndex = 0
        syncDisplayOrder()
        animateCardEntrance()
    }

    func goNext() {
        guard !displayOrder.isEmpty else { return }
        currentIndex = (currentIndex + 1) % displayOrder.count
        animateCardEntrance()
    }

    func goPrevious() {
        guard !displayOrder.isEmpty else { return }
        currentIndex = (currentIndex - 1 + displayOrder.count) % displayOrder.count
        animateCardEntrance()
    }

    func shuffleOrder() {
        guard !displayOrder.isEmpty else { return }
        displayOrder.shuffle()
        currentIndex = 0
        animateCardEntrance()
    }

    func goRandom() {
        guard displayOrder.count > 1 else { return }
        var next = currentIndex
        while next == currentIndex {
            next = Int.random(in: 0..<displayOrder.count)
        }
        currentIndex = next
        animateCardEntrance()
    }

    func animateCardEntrance() {
        cardScale = 0.88
        withAnimation(.spring(response: 0.45, dampingFraction: 0.72)) {
            cardScale = 1
        }
    }
}
