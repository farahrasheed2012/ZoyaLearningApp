//
//  LearningViewModel.swift
//  ZoyaLearn
//

import Foundation
import SwiftUI

@MainActor
final class LearningViewModel: ObservableObject {
    @Published var filter: ContentFilter = .letters
    @Published var currentIndex: Int = 0
    @Published var cardScale: CGFloat = 0.92
    @Published var jumpToCharacter: String?
    @Published private(set) var displayOrder: [LearningItem] = []

    var items: [LearningItem] { displayOrder }

    var currentItem: LearningItem? {
        guard !displayOrder.isEmpty else { return nil }
        let idx = min(max(currentIndex, 0), displayOrder.count - 1)
        return displayOrder[idx]
    }

    func syncDisplayOrder(shuffled: Bool = false) {
        let filtered = LearningItem.filtered(LearningItemData.all, by: filter)
        displayOrder = shuffled ? filtered.shuffled() : filtered
        currentIndex = min(currentIndex, max(displayOrder.count - 1, 0))
    }

    func applyJumpIfNeeded() {
        guard let target = jumpToCharacter,
              let idx = displayOrder.firstIndex(where: { $0.character == target }) else { return }
        currentIndex = idx
        jumpToCharacter = nil
        animateCardEntrance()
    }

    func setFilter(_ filter: ContentFilter) {
        self.filter = filter
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

    func jumpTo(_ character: String) {
        jumpToCharacter = character
    }

    func animateCardEntrance() {
        cardScale = 0.88
        withAnimation(.spring(response: 0.45, dampingFraction: 0.72)) {
            cardScale = 1
        }
    }
}
