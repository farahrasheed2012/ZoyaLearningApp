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
    private var blendParts: [BlendPart] { PhonicsPhonemeMap.displayParts(for: word.word) }

    var body: some View {
        VStack(spacing: 20) {
            Text(word.emoji)
                .font(.system(size: 72))
                .accessibilityHidden(true)

            blendBreakdown

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

                SpeakButton(label: "Blend") {
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

    private var blendBreakdown: some View {
        HStack(spacing: 10) {
            ForEach(Array(blendParts.enumerated()), id: \.offset) { index, part in
                if index > 0 {
                    Text("+")
                        .font(.title.bold())
                        .foregroundStyle(.secondary)
                        .padding(.top, 8)
                        .accessibilityHidden(true)
                }

                VStack(spacing: 8) {
                    Text(part.letters.uppercased())
                        .font(.system(size: partFontSize, weight: .bold, design: .rounded))
                        .foregroundStyle(ZLTheme.accent(for: index))
                        .padding(.horizontal, part.letters.count > 1 ? 16 : 8)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(ZLTheme.accent(for: index).opacity(0.12))
                        )

                    Text(part.sound)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .accessibilityLabel(blendAccessibilityLabel)
    }

    private var partFontSize: CGFloat {
        switch word.word.count {
        case ...2: return 64
        case 3: return blendParts.count == 2 ? 52 : 44
        default: return 44
        }
    }

    private var blendAccessibilityLabel: String {
        let chunks = blendParts.map { "\($0.letters) says \($0.sound)" }.joined(separator: ", then ")
        return "\(word.word): \(chunks)"
    }
}
