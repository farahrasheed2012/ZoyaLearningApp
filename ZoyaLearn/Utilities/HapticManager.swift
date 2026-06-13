//
//  HapticManager.swift
//  ZoyaLearn
//

import CoreHaptics
#if canImport(UIKit)
import UIKit
#endif

enum HapticManager {
    static func success() {
        #if os(iOS)
        if CHHapticEngine.capabilitiesForHardware().supportsHaptics {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
        #endif
    }

    static func lightImpact() {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        #endif
    }

    static func error() {
        #if os(iOS)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        #endif
    }
}
