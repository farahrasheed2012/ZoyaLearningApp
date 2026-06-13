//
//  Theme.swift
//  ZoyaLearn
//

import SwiftUI

enum ZLTheme {
    static let cornerRadius: CGFloat = 24
    static let shadowRadius: CGFloat = 8

    static let accentColors: [Color] = [
        Color(red: 1.0, green: 0.45, blue: 0.45),
        Color(red: 1.0, green: 0.72, blue: 0.30),
        Color(red: 0.98, green: 0.88, blue: 0.35),
        Color(red: 0.55, green: 0.85, blue: 0.55),
        Color(red: 0.45, green: 0.78, blue: 0.95),
        Color(red: 0.62, green: 0.55, blue: 0.95),
        Color(red: 0.95, green: 0.55, blue: 0.82),
        Color(red: 0.55, green: 0.90, blue: 0.85),
    ]

    static func accent(for index: Int) -> Color {
        accentColors[index % accentColors.count]
    }

    static func accent(for character: String) -> Color {
        let hash = abs(character.unicodeScalars.first?.value.hashValue ?? 0)
        return accent(for: hash)
    }

    static var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.95, green: 0.97, blue: 1.0),
                Color(red: 0.98, green: 0.94, blue: 1.0),
                Color(red: 0.94, green: 0.98, blue: 0.96),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

extension View {
    func zlCardStyle(accent: Color = ZLTheme.accentColors[0]) -> some View {
        self
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: ZLTheme.cornerRadius)
                    .fill(.background)
                    .shadow(color: accent.opacity(0.18), radius: ZLTheme.shadowRadius, y: 4)
            )
    }

    func inlineNavTitle() -> some View {
        #if os(iOS)
        navigationBarTitleDisplayMode(.inline)
        #else
        self
        #endif
    }

    func largeNavTitle() -> some View {
        #if os(iOS)
        navigationBarTitleDisplayMode(.large)
        #else
        self
        #endif
    }
}
