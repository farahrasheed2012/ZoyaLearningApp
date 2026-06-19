//
//  WorldMapViewModel.swift
//  ZoyaLearn
//

import Foundation
import SwiftUI

enum MapLocation: String, CaseIterable, Identifiable, Codable {
    case letterHouse
    case artCorner
    case libraryTree
    case backyard
    case trophyShed

    var id: String { rawValue }

    var title: String {
        switch self {
        case .letterHouse: return "Letter House"
        case .artCorner: return "Art Corner"
        case .libraryTree: return "Library Tree"
        case .backyard: return "The Backyard"
        case .trophyShed: return "Trophy Shed"
        }
    }

    var emoji: String {
        switch self {
        case .letterHouse: return "🏡"
        case .artCorner: return "🖍"
        case .libraryTree: return "🌳"
        case .backyard: return "🎮"
        case .trophyShed: return "🌟"
        }
    }

    var mapPosition: CGPoint {
        switch self {
        case .libraryTree: return CGPoint(x: 120, y: 140)
        case .letterHouse: return CGPoint(x: 340, y: 130)
        case .backyard: return CGPoint(x: 130, y: 340)
        case .artCorner: return CGPoint(x: 350, y: 330)
        case .trophyShed: return CGPoint(x: 240, y: 460)
        }
    }

    var invitation: String {
        switch self {
        case .libraryTree: return "Want to visit the Library Tree? 📚"
        case .letterHouse: return "Let's explore the Letter House! 🏡"
        case .backyard: return "Games are waiting in the Backyard! 🎮"
        case .artCorner: return "Time to draw at the Art Corner! 🖍"
        case .trophyShed: return "See your trophies in the shed! 🌟"
        }
    }

    /// Unlock order: letterHouse first, then neighbors sequentially.
    static var unlockOrder: [MapLocation] {
        [.letterHouse, .libraryTree, .artCorner, .backyard, .trophyShed]
    }

    func prerequisite(in visited: Set<MapLocation>) -> MapLocation? {
        guard let index = Self.unlockOrder.firstIndex(of: self), index > 0 else { return nil }
        return Self.unlockOrder[index - 1]
    }

    func isUnlocked(visited: Set<MapLocation>) -> Bool {
        guard let index = Self.unlockOrder.firstIndex(of: self) else { return false }
        if index == 0 { return true }
        return visited.contains(Self.unlockOrder[index - 1])
    }
}

@MainActor
final class WorldMapViewModel: ObservableObject {
    private static let visitedKey = "zoyalearn.visitedLocations"

    @Published var visitedLocations: Set<MapLocation> = []
    @Published var selectedLocation: MapLocation?
    @Published var avatarOffset: CGPoint = CGPoint(x: 240, y: 280)
    @Published var isWalking = false
    @Published var showInvitation: String?
    @Published var starJarBounce = false

    init() { load() }

    func greeting(for name: String) -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        let timeWord = hour < 12 ? "morning" : (hour < 17 ? "afternoon" : "evening")
        return "Good \(timeWord), \(name)!"
    }

    func isUnlocked(_ location: MapLocation) -> Bool {
        location.isUnlocked(visited: visitedLocations)
    }

    func visit(_ location: MapLocation) {
        visitedLocations.insert(location)
        save()
    }

    func walkTo(_ location: MapLocation, completion: @escaping () -> Void) {
        isWalking = true
        withAnimation(.easeInOut(duration: 0.6)) {
            avatarOffset = location.mapPosition
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {
            self.isWalking = false
            completion()
        }
    }

    func randomInvitation(for avatarName: String) {
        let unlocked = MapLocation.allCases.filter { isUnlocked($0) }
        guard let pick = unlocked.randomElement() else { return }
        showInvitation = pick.invitation.replacingOccurrences(of: "Zoya", with: avatarName)
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.showInvitation = nil
        }
    }

    func collectStar() {
        starJarBounce = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { self.starJarBounce = false }
    }

    private func load() {
        if let raw = UserDefaults.standard.stringArray(forKey: Self.visitedKey) {
            visitedLocations = Set(raw.compactMap(MapLocation.init(rawValue:)))
        }
        if visitedLocations.isEmpty { visitedLocations.insert(.letterHouse) }
    }

    private func save() {
        UserDefaults.standard.set(visitedLocations.map(\.rawValue), forKey: Self.visitedKey)
    }
}
