//
//  Theme.swift
//  ZoyaLearn — Bluey-inspired warm palette
//

import SwiftUI

enum ZLTheme {
    static let cornerRadius: CGFloat = 24
    static let shadowRadius: CGFloat = 8

    // Palette
    static let cream = Color(red: 0.992, green: 0.965, blue: 0.890)
    static let warmSky = Color(red: 0.659, green: 0.812, blue: 0.918)
    static let grass = Color(red: 0.482, green: 0.749, blue: 0.416)
    static let sun = Color(red: 0.961, green: 0.784, blue: 0.259)
    static let earth = Color(red: 0.769, green: 0.529, blue: 0.353)
    static let blush = Color(red: 0.949, green: 0.643, blue: 0.569)
    static let ink = Color(red: 0.239, green: 0.169, blue: 0.122)
    static let whiteSoft = Color(red: 1.0, green: 0.992, blue: 0.969)

    static let accentColors: [Color] = [blush, sun, grass, warmSky, earth]

    static func accent(for index: Int) -> Color {
        accentColors[index % accentColors.count]
    }

    static func accent(for character: String) -> Color {
        let hash = abs(character.unicodeScalars.first?.value.hashValue ?? 0)
        return accent(for: hash)
    }

    static var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [warmSky.opacity(0.45), cream, grass.opacity(0.18)],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    static var displayFont: Font { .system(.largeTitle, design: .rounded).weight(.bold) }
    static var headingFont: Font { .system(.title2, design: .rounded).weight(.bold) }
    static var bodyFont: Font { .system(.body, design: .rounded).weight(.semibold) }
    static var letterFont: Font { .system(size: 160, weight: .bold, design: .rounded) }

    enum Game {
        static let prompt = Font.system(.largeTitle, design: .rounded).weight(.bold)
        static let subtitle = Font.system(.title2, design: .rounded).weight(.semibold)
        static let progress = Font.system(.title3, design: .rounded).weight(.medium)
        static let character = Font.system(size: 56, weight: .bold, design: .rounded)
        static let tileCharacter = Font.system(size: 44, weight: .bold, design: .rounded)
        static let emoji = Font.system(size: 80)
        static let optionEmoji = Font.system(size: 56)
        static let optionWord = Font.system(.title, design: .rounded).weight(.semibold)
        static let choice = Font.system(size: 42, weight: .bold, design: .rounded)
        static let blankSlot = Font.system(size: 56, weight: .bold, design: .rounded)
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.4), value: configuration.isPressed)
    }
}

struct HandDrawnCard: ViewModifier {
    var fill: Color = ZLTheme.whiteSoft

    func body(content: Content) -> some View {
        content
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: ZLTheme.cornerRadius)
                    .fill(fill)
                    .shadow(color: ZLTheme.earth.opacity(0.15), radius: ZLTheme.shadowRadius, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: ZLTheme.cornerRadius)
                    .stroke(ZLTheme.earth.opacity(0.35), lineWidth: 2)
            )
    }
}

extension View {
    func zlCardStyle(accent: Color = ZLTheme.grass) -> some View {
        modifier(HandDrawnCard())
    }

    func zlInkText() -> some View {
        foregroundStyle(ZLTheme.ink)
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

    func wobble(wrong: Bool) -> some View {
        modifier(WobbleModifier(active: wrong))
    }
}

private struct WobbleModifier: ViewModifier {
    let active: Bool
    @State private var phase = false

    func body(content: Content) -> some View {
        content
            .offset(x: active && phase ? 6 : 0)
            .onChange(of: active) { _, on in
                guard on else { return }
                withAnimation(.default.repeatCount(3, autoreverses: true)) { phase.toggle() }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { phase = false }
            }
    }
}
