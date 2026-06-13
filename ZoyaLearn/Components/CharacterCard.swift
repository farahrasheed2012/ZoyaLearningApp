//
//  CharacterCard.swift
//  ZoyaLearn
//

import SwiftUI

struct CharacterCard: View {
    let item: LearningItem
    var scale: CGFloat = 1
    var showLearnedButton: Bool = false
    var isLearned: Bool = false
    var onMarkLearned: (() -> Void)?

    private var accent: Color { ZLTheme.accent(for: item.character) }

    var body: some View {
        VStack(spacing: 20) {
            Text(item.exampleEmoji)
                .font(.system(size: 72))
                .accessibilityHidden(true)

            Text(item.character)
                .font(.system(size: 96, weight: .bold, design: .rounded))
                .foregroundStyle(accent)
                .accessibilityLabel(item.type == .letter ? "Letter \(item.character)" : "Number \(item.character)")

            Text(item.exampleWord)
                .font(.system(.title, design: .rounded))
                .fontWeight(.semibold)

            Text(item.phonetic)
                .font(.title3)
                .foregroundStyle(.secondary)

            SpeakButton(label: "Listen") {
                SpeechManager.shared.speakLetterAndWord(item)
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
    }
}
