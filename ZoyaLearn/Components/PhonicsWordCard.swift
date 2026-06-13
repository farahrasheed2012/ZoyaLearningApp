//
//  PhonicsWordCard.swift
//  ZoyaLearn
//

import SwiftUI

struct PhonicsWordCard: View {
    let word: PhonicsWord
    var scale: CGFloat = 1
    var showLearnedButton: Bool = false
    var isLearned: Bool = false
    var onMarkLearned: (() -> Void)?

    private var accent: Color { ZLTheme.accent(for: word.word) }

    var body: some View {
        VStack(spacing: 20) {
            Text(word.emoji)
                .font(.system(size: 72))
                .accessibilityHidden(true)

            letterBreakdown

            Text(word.hint)
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)

            Text(word.displayFamily)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(accent)
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(Capsule().fill(accent.opacity(0.15)))

            HStack(spacing: 12) {
                SpeakButton(label: "Listen") {
                    SpeechManager.shared.speakWord(word)
                }

                SpeakButton(label: "Sound out") {
                    SpeechManager.shared.soundOutWord(word)
                }
            }

            if showLearnedButton, let onMarkLearned {
                Button {
                    onMarkLearned()
                } label: {
                    Label(isLearned ? "Learned!" : "Mark as learned", systemImage: isLearned ? "checkmark.circle.fill" : "checkmark.circle")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(isLearned ? Color.green.opacity(0.2) : accent.opacity(0.18))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(ScaleButtonStyle())
                .disabled(isLearned)
            }
        }
        .multilineTextAlignment(.center)
        .scaleEffect(scale)
        .zlCardStyle(accent: accent)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(word.word), \(word.hint)")
    }

    private var letterBreakdown: some View {
        HStack(spacing: 6) {
            ForEach(Array(word.letterParts.enumerated()), id: \.offset) { index, letter in
                Text(letter.uppercased())
                    .font(.system(size: word.letterParts.count <= 2 ? 72 : 56, weight: .bold, design: .rounded))
                    .foregroundStyle(ZLTheme.accent(for: index))
                    .frame(minWidth: word.letterParts.count <= 2 ? 52 : 44)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(ZLTheme.accent(for: index).opacity(0.12))
                    )

                if index < word.letterParts.count - 1 {
                    Text("·")
                        .font(.title.bold())
                        .foregroundStyle(.secondary)
                        .accessibilityHidden(true)
                }
            }
        }
        .accessibilityLabel("Word: \(word.word)")
    }
}
