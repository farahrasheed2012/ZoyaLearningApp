//
//  SpeakButton.swift
//  ZoyaLearn
//

import SwiftUI

struct SpeakButton: View {
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(label, systemImage: "speaker.wave.2.fill")
                .font(.headline)
                .padding(.horizontal, 18)
                .padding(.vertical, 12)
                .background(Capsule().fill(Color.accentColor.opacity(0.15)))
        }
        .buttonStyle(ScaleButtonStyle())
        .accessibilityLabel("Speak \(label)")
    }
}
