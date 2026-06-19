//
//  SpeakButton.swift
//  ZoyaLearn
//

import SwiftUI

struct SpeakButton: View {
    let label: String
    var tint: Color = ZLTheme.grass
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(label, systemImage: "speaker.wave.2.fill")
                .font(ZLTheme.bodyFont)
                .foregroundStyle(ZLTheme.ink)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(tint.opacity(0.18))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(tint.opacity(0.4), lineWidth: 2)
                )
        }
        .buttonStyle(ScaleButtonStyle())
        .accessibilityLabel("Speak \(label)")
    }
}
