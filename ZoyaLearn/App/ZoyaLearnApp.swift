//
//  ZoyaLearnApp.swift
//  ZoyaLearn
//

import SwiftUI

@main
struct ZoyaLearnApp: App {
    @StateObject private var progressStore = ProgressStore()
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(progressStore)
                .environmentObject(appState)
                .onAppear {
                    progressStore.beginSession()
                    appState.refreshTodaysLetter(progressStore: progressStore)
                }
                .onDisappear {
                    progressStore.endSession()
                }
        }
        #if os(macOS)
        .defaultSize(width: 960, height: 720)
        .commands {
            CommandMenu("Learn") {
                Button("Today's Letter") {
                    appState.showTodaysLetter(progressStore: progressStore)
                }
                .keyboardShortcut("t", modifiers: [.command, .shift])
            }
        }
        #endif
    }
}
