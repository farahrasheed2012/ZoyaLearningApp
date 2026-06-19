//
//  Avatar.swift
//  ZoyaLearn
//

import SwiftUI

enum AnimalSpecies: String, CaseIterable, Codable, Identifiable {
    case dog, cat, rabbit, bear, fox
    var id: String { rawValue }

    var label: String { rawValue.capitalized }

    var emoji: String {
        switch self {
        case .dog: return "🐕"
        case .cat: return "🐱"
        case .rabbit: return "🐰"
        case .bear: return "🐻"
        case .fox: return "🦊"
        }
    }
}

enum AvatarColorOption: String, CaseIterable, Codable, Identifiable {
    case blush, sun, grass, sky, earth, lavender
    var id: String { rawValue }

    var color: Color {
        switch self {
        case .blush: return ZLTheme.blush
        case .sun: return ZLTheme.sun
        case .grass: return ZLTheme.grass
        case .sky: return ZLTheme.warmSky
        case .earth: return ZLTheme.earth
        case .lavender: return Color(red: 0.72, green: 0.65, blue: 0.88)
        }
    }
}

struct Avatar: Codable, Equatable {
    var species: AnimalSpecies
    var color: AvatarColorOption
    var name: String

    static let defaultZoya = Avatar(species: .dog, color: .blush, name: "Zoya")
}

enum AvatarExpression {
    case idle, walking, happy, thinking, clapping, shrug
}

@MainActor
final class AvatarStore: ObservableObject {
    static let shared = AvatarStore()

    private static let key = "zoyalearn.avatar"

    @Published var avatar: Avatar? {
        didSet { save() }
    }

    @Published var hasCompletedOnboarding: Bool {
        didSet { UserDefaults.standard.set(hasCompletedOnboarding, forKey: "zoyalearn.onboarding") }
    }

    private init() {
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "zoyalearn.onboarding")
        if let data = UserDefaults.standard.data(forKey: Self.key),
           let decoded = try? JSONDecoder().decode(Avatar.self, from: data) {
            avatar = decoded
        }
    }

    func completeOnboarding(with avatar: Avatar) {
        self.avatar = avatar
        hasCompletedOnboarding = true
    }

    private func save() {
        guard let avatar, let data = try? JSONEncoder().encode(avatar) else { return }
        UserDefaults.standard.set(data, forKey: Self.key)
    }
}
