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

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Letter quiz!")
                    .font(ZLTheme.headingFont)
                    .foregroundStyle(ZLTheme.ink)

                Text("Which letter says")
                    .font(ZLTheme.bodyFont)
                    .foregroundStyle(ZLTheme.earth)

                Text("/\(item.soundLabel)/")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(ZLTheme.grass)

                Text("like \(item.exampleWord.lowercased()) \(item.exampleEmoji)")
                    .font(ZLTheme.bodyFont)
                    .foregroundStyle(ZLTheme.earth)

                SpeakButton(label: "Hear the sound") {
                    SpeechManager.shared.speakLetterSound(item)
                }

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(choices, id: \.self) { choice in
                        Button {
                            answer(choice)
                        } label: {
                            Text(choice)
                                .font(.system(size: 44, weight: .bold, design: .rounded))
                                .frame(maxWidth: .infinity, minHeight: 72)
                                .background(ZLTheme.whiteSoft)
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(ZLTheme.earth.opacity(0.3), lineWidth: 2)
                                )
                        }
                        .buttonStyle(ScaleButtonStyle())
                        .disabled(passed)
                    }
                }
                .padding(.horizontal)

                if let feedback {
                    Text(feedback)
                        .font(ZLTheme.bodyFont)
                        .foregroundStyle(passed ? ZLTheme.grass : ZLTheme.blush)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Spacer()
            }
            .padding(.vertical)
            .navigationTitle(item.displayPair)
            .inlineNavTitle()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { onDismiss() }
                }
            }
            .onAppear {
                choices = LetterQuizView.makeChoices(for: item)
                SpeechManager.shared.speakLetterSound(item)
            }
        }
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
