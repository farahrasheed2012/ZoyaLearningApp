//
//  TraceView.swift
//  ZoyaLearn
//

import SwiftUI

struct TraceView: View {
    @EnvironmentObject var progressStore: ProgressStore
    @State private var filter: ContentFilter = .letters
    @State private var index = 0
    @State private var strokes: [[CGPoint]] = []
    @State private var currentStroke: [CGPoint] = []
    @State private var showConfetti = false
    @State private var successGlow = false

    private var items: [LearningItem] { LearningItem.filtered(LearningItemData.all, by: filter) }
    private var item: LearningItem { items[min(index, max(items.count - 1, 0))] }

    var body: some View {
        VStack(spacing: 16) {
            Picker("Content", selection: $filter) {
                ForEach(ContentFilter.allCases) { Text($0.rawValue).tag($0) }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            Text("Trace \(item.character)")
                .font(.system(.title2, design: .rounded).weight(.bold))

            ZStack {
                RoundedRectangle(cornerRadius: ZLTheme.cornerRadius)
                    .fill(ZLPlatformColor.cardBackground)
                    .shadow(color: .black.opacity(0.08), radius: ZLTheme.shadowRadius)

                Text(item.character)
                    .font(.system(size: 180, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary.opacity(0.12))

                Canvas { context, size in
                    for stroke in strokes + [currentStroke] {
                        guard stroke.count > 1 else { continue }
                        var path = Path()
                        path.move(to: stroke[0])
                        for p in stroke.dropFirst() { path.addLine(to: p) }
                        context.stroke(path, with: .color(successGlow ? .green : .accentColor), lineWidth: 8)
                    }
                }
                .gesture(drawGesture)
            }
            .frame(height: 320)
            .padding(.horizontal)
            .overlay(RoundedRectangle(cornerRadius: ZLTheme.cornerRadius).stroke(successGlow ? Color.green : .clear, lineWidth: 4).padding(.horizontal))

            HStack(spacing: 16) {
                Button("Clear") { clearCanvas() }
                    .buttonStyle(.bordered)
                Button("Done tracing") { evaluateTrace() }
                    .buttonStyle(.borderedProminent)
            }
            .buttonStyle(ScaleButtonStyle())

            HStack {
                Button { step(-1) } label: { Image(systemName: "chevron.left") }
                Spacer()
                Text(item.exampleEmoji + " " + item.exampleWord)
                Spacer()
                Button { step(1) } label: { Image(systemName: "chevron.right") }
            }
            .padding(.horizontal, 24)
            .font(.headline)
        }
        .overlay { ConfettiView(isActive: showConfetti) }
        .navigationTitle("Trace")
        .inlineNavTitle()
        .onChange(of: filter) { _, _ in index = 0; clearCanvas() }
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

    private func clearCanvas() {
        strokes = []
        currentStroke = []
        successGlow = false
        showConfetti = false
    }

    private func step(_ delta: Int) {
        guard !items.isEmpty else { return }
        index = (index + delta + items.count) % items.count
        clearCanvas()
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
