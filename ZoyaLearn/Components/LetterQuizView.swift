//
//  LetterQuizView.swift
//  ZoyaLearn
//

import SwiftUI

struct LetterQuizView: View {
    let item: LearningItem
    var onPass: () -> Void
    var onDismiss: () -> Void

    @State private var choices: [String] = []
    @State private var feedback: String?
    @State private var passed = false

    private var letterAccent: Color { ZLTheme.accent(for: item.character) }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Letter quiz!")
                    .font(ZLTheme.headingFont)
                    .foregroundStyle(ZLTheme.ink)

                Text("Which letter says")
                    .font(ZLTheme.bodyFont)
                    .foregroundStyle(ZLTheme.ink.opacity(0.75))

                Text("/\(item.soundLabel)/")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(ZLTheme.grass)

                Text("like \(item.exampleWord.lowercased()) \(item.exampleEmoji)")
                    .font(ZLTheme.bodyFont)
                    .foregroundStyle(ZLTheme.ink.opacity(0.75))

                SpeakButton(label: "Hear the sound", tint: letterAccent) {
                    SpeechManager.shared.speakLetterSound(item)
                }
                .padding(.horizontal)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(choices, id: \.self) { choice in
                        Button {
                            answer(choice)
                        } label: {
                            Text(choice)
                                .font(.system(size: 44, weight: .bold, design: .rounded))
                                .foregroundStyle(ZLTheme.ink)
                                .frame(maxWidth: .infinity, minHeight: 72)
                                .background(ZLTheme.whiteSoft)
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(ZLTheme.earth.opacity(0.45), lineWidth: 2)
                                )
                        }
                        .buttonStyle(.plain)
                        .disabled(passed)
                    }
                }
                .padding(.horizontal)

                if let feedback {
                    Text(feedback)
                        .font(ZLTheme.bodyFont)
                        .foregroundStyle(passed ? ZLTheme.grass : ZLTheme.earth)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Spacer(minLength: 0)
            }
            .padding(.vertical)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ZLTheme.cream)
            .navigationTitle(item.displayPair)
            .inlineNavTitle()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { onDismiss() }
                        .foregroundStyle(ZLTheme.ink)
                }
            }
            .onAppear {
                choices = LetterQuizView.makeChoices(for: item)
                SpeechManager.shared.speakLetterSound(item)
            }
        }
        .preferredColorScheme(.light)
        #if os(macOS)
        .frame(minWidth: 420, minHeight: 520)
        #endif
    }

    private func answer(_ choice: String) {
        if choice == item.character {
            passed = true
            feedback = "Yes! \(item.character) says /\(item.soundLabel)/!"
            SoundManager.shared.playChime()
            HapticManager.success()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                onPass()
            }
        } else {
            feedback = "Try again — listen to the sound."
            SoundManager.shared.playWoodTap()
            HapticManager.error()
            SpeechManager.shared.speakLetterSound(item)
        }
    }

    static func makeChoices(for item: LearningItem) -> [String] {
        var pool = LearningItemData.letters.map(\.character).filter { $0 != item.character }
        pool.shuffle()
        return ([item.character] + pool.prefix(3)).shuffled()
    }
}
