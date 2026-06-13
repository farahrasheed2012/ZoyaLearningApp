//
//  Badge.swift
//  ZoyaLearn
//

import Foundation

struct Badge: Identifiable, Hashable, Codable {
    let id: String
    let title: String
    let emoji: String
    let starsRequired: Int
}

enum BadgeCatalog {
    static let all: [Badge] = [
        Badge(id: "explorer", title: "Letter Explorer", emoji: "🌟", starsRequired: 10),
        Badge(id: "ninja", title: "Number Ninja", emoji: "🔢", starsRequired: 25),
        Badge(id: "champion", title: "ABC Champion", emoji: "🏆", starsRequired: 50),
        Badge(id: "superstar", title: "Super Star", emoji: "⭐️", starsRequired: 100),
    ]
}
