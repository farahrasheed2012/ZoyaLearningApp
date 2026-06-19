//
//  ParentDashboardView.swift
//  ZoyaLearn
//

import SwiftUI

struct ParentDashboardView: View {
    @EnvironmentObject var progressStore: ProgressStore
    @Environment(\.dismiss) private var dismiss
    @State private var showResetConfirm = false
    @State private var showShare = false

    private var viewModel: ParentDashboardViewModel {
        ParentDashboardViewModel(progressStore: progressStore)
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Overview") {
                    LabeledContent("Total time", value: "\(viewModel.totalMinutes) min")
                    LabeledContent("Stars earned", value: "\(progressStore.totalStars)")
                    LabeledContent("Streak", value: "\(progressStore.currentStreak) days")
                }

                Section("This week's letters") {
                    ForEach(viewModel.weeklyLetterPlan) { item in
                        HStack {
                            Text(item.displayPair)
                                .font(.headline)
                            Text(item.exampleWord)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(viewModel.progressStore.masteryLevel(for: item.character).rawValue)
                                .font(.caption.weight(.semibold))
                        }
                    }
                }

                Section("Mastery") {
                    ForEach(viewModel.masteryRows) { row in
                        HStack {
                            Text(row.character)
                                .font(.headline)
                                .frame(width: 28)
                            Text(row.type.rawValue.capitalized)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(row.level.rawValue)
                                .font(.caption.weight(.semibold))
                        }
                    }
                }

                Section("Practice days") {
                    if viewModel.practiceDayKeys.isEmpty {
                        Text("No practice days yet")
                    } else {
                        ForEach(viewModel.practiceDayKeys, id: \.self) { day in
                            Text(day)
                        }
                    }
                }

                Section {
                    Button("Export summary") { showShare = true }
                    Button("Reset progress", role: .destructive) { showResetConfirm = true }
                }
            }
            .navigationTitle("Parent Dashboard")
            .inlineNavTitle()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .alert("Reset all progress?", isPresented: $showResetConfirm) {
                Button("Cancel", role: .cancel) {}
                Button("Reset", role: .destructive) {
                    progressStore.resetAllProgress()
                }
            } message: {
                Text("This cannot be undone.")
            }
            .sheet(isPresented: $showShare) {
                #if os(iOS)
                ShareSheet(text: viewModel.exportSummary())
                #else
                VStack(spacing: 16) {
                    Text("Progress Summary").font(.headline)
                    ScrollView { Text(viewModel.exportSummary()).textSelection(.enabled).padding() }
                    Button("Done") { showShare = false }
                }
                .padding()
                .frame(minWidth: 420, minHeight: 360)
                #endif
            }
        }
    }
}

#if os(iOS)
import UIKit
struct ShareSheet: UIViewControllerRepresentable {
    let text: String
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: [text], applicationActivities: nil)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
#endif
