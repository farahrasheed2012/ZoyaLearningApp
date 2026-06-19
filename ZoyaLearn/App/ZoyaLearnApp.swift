//
//  ZoyaLearnApp.swift
//  ZoyaLearn
//

import SwiftUI

@main
struct ZoyaLearnApp: App {
    @StateObject private var progressStore = ProgressStore()
    @StateObject private var appState = AppState()
    @StateObject private var avatarStore = AvatarStore.shared

    var body: some Scene {
        WindowGroup {
            Group {
                if avatarStore.hasCompletedOnboarding {
                    WorldRootView()
                } else {
                    AvatarPickerView(avatarStore: avatarStore)
                }
            }
            .environmentObject(progressStore)
            .environmentObject(appState)
            .environmentObject(avatarStore)
            .onAppear {
                progressStore.beginSession()
                appState.refreshTodaysLesson(progressStore: progressStore)
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
