//
//  MainTabView.swift
//  ZoyaLearn
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var progressStore: ProgressStore
    @EnvironmentObject var appState: AppState

    var body: some View {
        Group {
            #if os(macOS)
            macLayout
            #else
            iosLayout
            #endif
        }
        .onReceive(NotificationCenter.default.publisher(for: .zlJumpToCharacter)) { _ in
            appState.selectedTab = .learn
        }
    }

    #if os(iOS)
    private var iosLayout: some View {
        TabView(selection: $appState.selectedTab) {
            tabRoot(.learn) { LearnView() }
            tabRoot(.trace) { TraceView() }
            tabRoot(.flashcards) { FlashcardsStudyView() }
            tabRoot(.games) { NavigationStack { GamesHubView() } }
            tabRoot(.progress) { ProgressTabView() }
        }
    }
    #endif

    #if os(macOS)
    private var macLayout: some View {
        NavigationSplitView {
            List(selection: $appState.selectedTab) {
                Section("ZoyaLearn") {
                    ForEach(AppTab.allCases) { tab in
                        Label(tab.title, systemImage: tab.systemImage)
                            .tag(tab)
                    }
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("ZoyaLearn")
            .navigationSplitViewColumnWidth(min: 200, ideal: 220, max: 260)
        } detail: {
            detail(for: appState.selectedTab)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(ZLPlatformColor.groupedBackground)
        }
        .navigationSplitViewStyle(.balanced)
        .frame(minWidth: 800, minHeight: 600)
    }

    @ViewBuilder
    private func detail(for tab: AppTab) -> some View {
        switch tab {
        case .learn: NavigationStack { LearnView() }
        case .trace: NavigationStack { TraceView() }
        case .flashcards: NavigationStack { FlashcardsStudyView() }
        case .games: NavigationStack { GamesHubView() }
        case .progress: NavigationStack { ProgressTabView() }
        }
    }
    #endif

    private func tabRoot<Content: View>(_ tab: AppTab, @ViewBuilder content: () -> Content) -> some View {
        NavigationStack {
            content()
        }
        .tabItem {
            Label(tab.title, systemImage: tab.systemImage)
        }
        .tag(tab)
        .accessibilityLabel("\(tab.title) tab")
    }
}
