//
//  AvatarPickerView.swift
//  ZoyaLearn
//

import SwiftUI

struct AvatarPickerView: View {
    @ObservedObject var avatarStore: AvatarStore
    @State private var species: AnimalSpecies = .dog
    @State private var color: AvatarColorOption = .blush
    @State private var name = "Zoya"

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                Text("Hi! I'm Zoya.")
                    .font(ZLTheme.displayFont)
                    .foregroundStyle(ZLTheme.ink)

                Text("What do I look like?")
                    .font(ZLTheme.headingFont)
                    .foregroundStyle(ZLTheme.earth)

                ZoyaAvatarView(
                    avatar: Avatar(species: species, color: color, name: name),
                    expression: .happy,
                    size: 120
                )
                .padding(.vertical, 8)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Pick your animal")
                        .font(ZLTheme.bodyFont)
                        .foregroundStyle(ZLTheme.ink)
                    HStack(spacing: 10) {
                        ForEach(AnimalSpecies.allCases) { animal in
                            Button {
                                species = animal
                                HapticManager.lightImpact()
                            } label: {
                                Text(animal.emoji)
                                    .font(.largeTitle)
                                    .padding(12)
                                    .background(species == animal ? ZLTheme.sun.opacity(0.35) : ZLTheme.whiteSoft)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Pick your color")
                        .font(ZLTheme.bodyFont)
                    HStack(spacing: 10) {
                        ForEach(AvatarColorOption.allCases) { option in
                            Button { color = option } label: {
                                Circle()
                                    .fill(option.color)
                                    .frame(width: 36, height: 36)
                                    .overlay(
                                        Circle()
                                            .stroke(color == option ? ZLTheme.ink : .clear, lineWidth: 3)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Your name")
                        .font(ZLTheme.bodyFont)
                    TextField("Name", text: $name)
                        .font(ZLTheme.headingFont)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(ZLTheme.whiteSoft)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }

                Button {
                    let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
                    avatarStore.completeOnboarding(with: Avatar(
                        species: species,
                        color: color,
                        name: trimmed.isEmpty ? "Zoya" : trimmed
                    ))
                    SoundManager.shared.playChime()
                    HapticManager.success()
                } label: {
                    Text("Let's explore!")
                        .font(ZLTheme.headingFont)
                        .foregroundStyle(ZLTheme.whiteSoft)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(ZLTheme.grass)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                }
                .buttonStyle(ScaleButtonStyle())
            }
            .padding(24)
        }
        .background(ZLTheme.backgroundGradient.ignoresSafeArea())
    }
}
