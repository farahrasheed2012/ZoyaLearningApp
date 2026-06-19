//
//  CharacterCardView.swift
//  ZoyaLearn
//

import SwiftUI

struct IllustratedObjectView: View {
    let item: LearningItem
    var compact: Bool = false

    var body: some View {
        ZStack {
            Circle()
                .fill(ZLTheme.sun.opacity(0.25))
                .frame(width: compact ? 96 : 120, height: compact ? 96 : 120)
            Text(item.exampleEmoji)
                .font(.system(size: compact ? 56 : 72))
        }
        .accessibilityLabel(item.exampleWord)
    }
}

struct CharacterCardView: View {
    @EnvironmentObject var progressStore: ProgressStore
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss

    let item: LearningItem
    var scale: CGFloat = 1
    var showLearnedButton: Bool = false
    var isLearned: Bool = false
    var onMarkLearned: (() -> Void)?
    var onTapCharacter: (() -> Void)?

    @State private var showQuiz = false

    private var accent: Color { ZLTheme.accent(for: item.character) }
    private var progress: CharacterProgress { progressStore.progress(for: item.character) }
    private var isLetter: Bool { item.type == .letter }

    var body: some View {
        VStack(spacing: 14) {
            IllustratedObjectView(item: item, compact: true)

            Button {
                onTapCharacter?()
                SpeechManager.shared.speakLetterAndWord(item)
            } label: {
                letterDisplay
            }
            .buttonStyle(.plain)
            .accessibilityLabel(isLetter ? "Letter \(item.displayPair)" : "Number \(item.character)")

            if isLetter {
                Text("Says /\(item.soundLabel)/")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(ZLTheme.grass)
            }

            Text(item.exampleWord)
                .font(.title2.weight(.bold))
                .zlInkText()

            Text(item.funFact)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(ZLTheme.earth)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)

            SpeakButton(label: isLetter ? "Hear the sound" : "Listen again", tint: accent) {
                if isLetter {
                    SpeechManager.shared.speakLetterSound(item)
                } else {
                    SpeechManager.shared.speakLetterAndWord(item)
                }
            }

            if showLearnedButton, isLetter {
                masteryChecklist
                masteryAction
            } else if showLearnedButton, let onMarkLearned {
                Button(action: onMarkLearned) {
                    Label(isLearned ? "Room glows!" : "I learned this!", systemImage: isLearned ? "sparkles" : "heart.fill")
                        .font(ZLTheme.bodyFont)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(isLearned ? ZLTheme.grass.opacity(0.25) : accent.opacity(0.18))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .buttonStyle(ScaleButtonStyle())
                .disabled(isLearned || !progressStore.canEarnMastered(for: item.character))
            }
        }
        .multilineTextAlignment(.center)
        .padding(.vertical, 4)
        .opacity(Double(min(max(scale, 0.85), 1)))
        .zlCardStyle()
        .sheet(isPresented: $showQuiz) {
            LetterQuizView(
                item: item,
                onPass: {
                    progressStore.markQuizPassed(item.character)
                    showQuiz = false
                },
                onDismiss: { showQuiz = false }
            )
        }
    }

    private var letterDisplay: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text(item.character)
                .font(.system(size: 88, weight: .bold, design: .rounded))
                .foregroundStyle(accent)
            if isLetter {
                Text(item.lowercaseCharacter)
                    .font(.system(size: 52, weight: .bold, design: .rounded))
                    .foregroundStyle(accent.opacity(0.85))
            }
        }
        .shadow(color: ZLTheme.earth.opacity(0.2), radius: 0, y: 2)
    }

    private var masteryChecklist: some View {
        HStack(spacing: 8) {
            checklistChip("Seen", done: progress.seen)
            checklistChip("Traced", done: progress.practiced)
            checklistChip("Quiz", done: progress.quizPassed)
        }
    }

    @ViewBuilder
    private var masteryAction: some View {
        if isLearned {
            Label("Room glows!", systemImage: "sparkles")
                .font(ZLTheme.bodyFont)
                .foregroundStyle(ZLTheme.grass)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(ZLTheme.grass.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 20))
        } else if !progress.practiced {
            Button(action: goTrace) {
                Label("Go trace at Art Corner", systemImage: "pencil.tip")
                    .font(ZLTheme.bodyFont)
                    .foregroundStyle(ZLTheme.ink)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(ZLTheme.sun.opacity(0.25))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(ZLTheme.earth.opacity(0.3), lineWidth: 2)
                    )
            }
            .buttonStyle(ScaleButtonStyle())
        } else if !progress.quizPassed {
            Button { showQuiz = true } label: {
                Label("Letter quiz!", systemImage: "questionmark.circle.fill")
                    .font(ZLTheme.bodyFont)
                    .foregroundStyle(ZLTheme.ink)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(accent.opacity(0.18))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .buttonStyle(ScaleButtonStyle())
        } else if let onMarkLearned {
            Button(action: onMarkLearned) {
                Label("I learned this!", systemImage: "heart.fill")
                    .font(ZLTheme.bodyFont)
                    .foregroundStyle(ZLTheme.ink)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(accent.opacity(0.18))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .buttonStyle(ScaleButtonStyle())
        }
    }

    private func goTrace() {
        appState.lessonFocusCharacter = item.character
        appState.beginLessonStep(.trace)
        dismiss()
    }

    private func checklistChip(_ title: String, done: Bool) -> some View {
        HStack(spacing: 4) {
            Image(systemName: done ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(done ? ZLTheme.grass : ZLTheme.earth.opacity(0.4))
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(done ? ZLTheme.ink : ZLTheme.earth)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(ZLTheme.cream)
        .clipShape(Capsule())
    }
}

// Backward-compatible alias
typealias CharacterCard = CharacterCardView
