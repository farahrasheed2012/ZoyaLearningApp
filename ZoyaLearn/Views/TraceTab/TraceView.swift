//
//  TraceView.swift
//  ZoyaLearn
//

import SwiftUI

private enum TraceCasing: String, CaseIterable, Identifiable {
    case uppercase = "A"
    case lowercase = "a"

    var id: String { rawValue }
}

struct TraceView: View {
    @EnvironmentObject var progressStore: ProgressStore
    @EnvironmentObject var appState: AppState

    var embeddedInArtCorner: Bool = false

    @State private var filter: ContentFilter = .letters
    @State private var casing: TraceCasing = .uppercase
    @State private var index = 0
    @State private var strokes: [[CGPoint]] = []
    @State private var currentStroke: [CGPoint] = []
    @State private var showConfetti = false
    @State private var successGlow = false

    private var items: [LearningItem] { LearningItem.filtered(LearningItemData.all, by: filter) }
    private var item: LearningItem { items[min(index, max(items.count - 1, 0))] }

    private var traceCharacter: String {
        switch casing {
        case .uppercase: return item.character
        case .lowercase: return item.lowercaseCharacter
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            if !embeddedInArtCorner {
                Picker("Content", selection: $filter) {
                    ForEach(ContentFilter.allCases) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
            }

            if item.type == .letter {
                Picker("Case", selection: $casing) {
                    ForEach(TraceCasing.allCases) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
            }

            Text("Trace \(traceCharacter)")
                .font(.system(.title2, design: .rounded).weight(.bold))
                .foregroundStyle(ZLTheme.ink)

            traceCanvas
                .frame(height: 320)
                .padding(.horizontal)

            HStack(spacing: 16) {
                Button("Clear") { clearCanvas() }
                    .buttonStyle(.bordered)
                Button("Done tracing") { evaluateTrace() }
                    .buttonStyle(.borderedProminent)
                    .tint(ZLTheme.grass)
            }
            .buttonStyle(ScaleButtonStyle())

            HStack {
                Button { step(-1) } label: { Image(systemName: "chevron.left") }
                Spacer()
                VStack(spacing: 2) {
                    Text(item.exampleEmoji + " " + item.exampleWord)
                    if item.type == .letter {
                        Text("/\(item.soundLabel)/")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(ZLTheme.grass)
                    }
                }
                Spacer()
                Button { step(1) } label: { Image(systemName: "chevron.right") }
            }
            .padding(.horizontal, 24)
            .font(.headline)
        }
        .overlay { ConfettiView(isActive: showConfetti) }
        .modifier(TraceNavigationTitle(show: !embeddedInArtCorner))
        .onAppear { focusLessonLetterIfNeeded() }
        .onChange(of: filter) { _, _ in index = 0; clearCanvas() }
        .onChange(of: casing) { _, _ in clearCanvas() }
        .onChange(of: index) { _, _ in clearCanvas() }
        .onChange(of: appState.lessonFocusCharacter) { _, _ in focusLessonLetterIfNeeded() }
    }

    private var traceCanvas: some View {
        ZStack {
            RoundedRectangle(cornerRadius: ZLTheme.cornerRadius)
                .fill(ZLTheme.whiteSoft)
                .shadow(color: ZLTheme.earth.opacity(0.12), radius: ZLTheme.shadowRadius, y: 4)

            Text(traceCharacter)
                .font(.system(size: 200, weight: .bold, design: .rounded))
                .foregroundStyle(ZLTheme.ink.opacity(0.1))
                .allowsHitTesting(false)

            Canvas { context, size in
                for stroke in strokes + [currentStroke] {
                    guard stroke.count > 1 else { continue }
                    var path = Path()
                    path.move(to: stroke[0])
                    for point in stroke.dropFirst() { path.addLine(to: point) }
                    context.stroke(
                        path,
                        with: .color(successGlow ? ZLTheme.grass : ZLTheme.warmSky),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round)
                    )
                }
            }
            .contentShape(Rectangle())
            .gesture(drawGesture)
        }
        .clipShape(RoundedRectangle(cornerRadius: ZLTheme.cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: ZLTheme.cornerRadius)
                .stroke(successGlow ? ZLTheme.grass : ZLTheme.earth.opacity(0.25), lineWidth: successGlow ? 3 : 2)
        )
    }

    private var drawGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                currentStroke.append(value.location)
            }
            .onEnded { _ in
                if !currentStroke.isEmpty {
                    strokes.append(currentStroke)
                    currentStroke = []
                }
            }
    }

    private func focusLessonLetterIfNeeded() {
        guard let focus = appState.lessonFocusCharacter,
              let idx = items.firstIndex(where: { $0.character == focus }) else { return }
        index = idx
        casing = .uppercase
        clearCanvas()
    }

    private func clearCanvas() {
        strokes = []
        currentStroke = []
        successGlow = false
        showConfetti = false
    }

    private func step(_ delta: Int) {
        guard !items.isEmpty else { return }
        index = (index + delta + items.count) % items.count
    }

    private func evaluateTrace() {
        let pointCount = strokes.flatMap { $0 }.count + currentStroke.count
        guard pointCount > 40 else { return }
        successGlow = true
        showConfetti = true
        progressStore.markPracticed(item.character)
        progressStore.addStars(2)
        HapticManager.success()
        SpeechManager.shared.speakPraise()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            showConfetti = false
        }
    }
}

private struct TraceNavigationTitle: ViewModifier {
    let show: Bool

    func body(content: Content) -> some View {
        if show {
            content
                .navigationTitle("Trace")
                .inlineNavTitle()
        } else {
            content
        }
    }
}
