//
//  PhonicsView.swift
//  ZoyaLearn
//

import SwiftUI

struct PhonicsView: View {
    @EnvironmentObject var progressStore: ProgressStore
    @StateObject private var viewModel = PhonicsViewModel()
    @State private var hueShift: Double = 0

    var body: some View {
        ZStack {
            animatedBackground
            VStack(spacing: 16) {
                lengthPicker
                familyPicker

                if let info = viewModel.selectedFamilyInfo {
                    familyBanner(info)
                }

                if let word = viewModel.currentWord {
                    PhonicsWordCard(
                        word: word,
                        scale: viewModel.cardScale,
                        showLearnedButton: true,
                        isLearned: progressStore.phonicsProgress(for: word.word).mastered,
                        onMarkLearned: {
                            progressStore.markPhonicsMastered(word.word)
                            progressStore.addStars(1)
                            HapticManager.success()
                        }
                    )
                    .padding(.horizontal)
                    .gesture(swipeGesture)

                    navigationRow
                } else {
                    ContentUnavailableView("No words", systemImage: "text.book.closed")
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Phonics")
        .largeNavTitle()
        .onAppear {
            viewModel.syncDisplayOrder()
            viewModel.animateCardEntrance()
            if let word = viewModel.currentWord {
                progressStore.markPhonicsSeen(word.word)
            }
            withAnimation(.linear(duration: 12).repeatForever(autoreverses: true)) {
                hueShift = 1
            }
        }
        .onChange(of: viewModel.currentIndex) { _, _ in
            if let word = viewModel.currentWord {
                progressStore.markPhonicsSeen(word.word)
            }
        }
        #if os(macOS)
        .onMoveCommand { direction in
            switch direction {
            case .left: viewModel.goPrevious()
            case .right: viewModel.goNext()
            default: break
            }
        }
        #endif
        .badgeAlert()
    }

    private var lengthPicker: some View {
        Picker("Word length", selection: $viewModel.lengthFilter) {
            ForEach(PhonicsLength.allCases) { filter in
                Text(filter.rawValue).tag(filter)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        .onChange(of: viewModel.lengthFilter) { _, _ in
            viewModel.currentIndex = 0
            viewModel.syncDisplayOrder()
            viewModel.animateCardEntrance()
        }
    }

    private var familyPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Word family", systemImage: "music.note.list")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    familyChip(title: "All Families", subtitle: "Every word", suffix: nil)

                    ForEach(viewModel.availableFamilies) { family in
                        familyChip(
                            title: family.displayName,
                            subtitle: family.sampleLabel,
                            suffix: family.suffix
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private func familyChip(title: String, subtitle: String, suffix: String?) -> some View {
        let isSelected = viewModel.familyFilter == suffix
        return Button {
            viewModel.selectFamily(suffix)
            HapticManager.lightImpact()
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.bold))
                Text(subtitle)
                    .font(.caption2)
                    .lineLimit(1)
            }
            .foregroundStyle(isSelected ? Color.white : Color.primary)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(isSelected ? Color.accentColor : Color.accentColor.opacity(0.12))
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(title), \(subtitle)")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private func familyBanner(_ info: WordFamilyInfo) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "text.word.spacing")
                .foregroundStyle(Color.accentColor)
            VStack(alignment: .leading, spacing: 2) {
                Text("Practicing \(info.displayName) words")
                    .font(.subheadline.weight(.semibold))
                Text(info.words.map(\.word).joined(separator: " · "))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            Spacer()
            Text("\(info.words.count)")
                .font(.caption.weight(.bold))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Capsule().fill(Color.accentColor.opacity(0.15)))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.background.opacity(0.85))
        )
        .padding(.horizontal)
    }

    private var animatedBackground: some View {
        ZLTheme.backgroundGradient
            .hueRotation(.degrees(hueShift * 8))
            .ignoresSafeArea()
    }

    private var navigationRow: some View {
        VStack(spacing: 14) {
            HStack(spacing: 16) {
                navButton(title: "Previous", systemImage: "chevron.left") {
                    viewModel.goPrevious()
                }

                Text("\(viewModel.currentIndex + 1) of \(viewModel.items.count)")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .frame(minWidth: 88)

                navButton(title: "Next", systemImage: "chevron.right") {
                    viewModel.goNext()
                }
            }

            HStack(spacing: 12) {
                navButton(title: "Shuffle", systemImage: "shuffle") {
                    viewModel.shuffleOrder()
                    HapticManager.lightImpact()
                }

                navButton(title: "Random", systemImage: "dice.fill") {
                    viewModel.goRandom()
                    HapticManager.lightImpact()
                }
            }
        }
        .padding(.horizontal)
    }

    private func navButton(title: String, systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Capsule().fill(Color.accentColor.opacity(0.14)))
        }
        .buttonStyle(ScaleButtonStyle())
        .foregroundStyle(Color.accentColor)
    }

    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 40)
            .onEnded { value in
                if value.translation.width < -40 { viewModel.goNext() }
                else if value.translation.width > 40 { viewModel.goPrevious() }
            }
    }
}
