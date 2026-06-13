//
//  LearningViewModel.swift
//  ZoyaLearn
//

import Foundation
import SwiftUI

@MainActor
final class LearningViewModel: ObservableObject {
    @Published var filter: ContentFilter = .all
    @Published var currentIndex: Int = 0
    @Published var cardScale: CGFloat = 0.92
    @Published var jumpToCharacter: String?

    var items: [LearningItem] {
        LearningItem.filtered(LearningItemData.all, by: filter)
    }

    var currentItem: LearningItem? {
        guard !items.isEmpty else { return nil }
        let idx = min(max(currentIndex, 0), items.count - 1)
        return items[idx]
    }

    func applyJumpIfNeeded() {
        guard let target = jumpToCharacter,
              let idx = items.firstIndex(where: { $0.character == target }) else { return }
        currentIndex = idx
        jumpToCharacter = nil
        animateCardEntrance()
    }

    func setFilter(_ filter: ContentFilter) {
        self.filter = filter
        currentIndex = 0
        animateCardEntrance()
    }

    func goNext() {
        guard !items.isEmpty else { return }
        currentIndex = (currentIndex + 1) % items.count
        animateCardEntrance()
    }

    func goPrevious() {
        guard !items.isEmpty else { return }
        currentIndex = (currentIndex - 1 + items.count) % items.count
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
