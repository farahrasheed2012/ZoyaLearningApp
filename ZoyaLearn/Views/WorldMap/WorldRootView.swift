//
//  WorldRootView.swift
//  ZoyaLearn
//

import SwiftUI

struct WorldRootView: View {
    @EnvironmentObject var progressStore: ProgressStore
    @EnvironmentObject var avatarStore: AvatarStore
    @EnvironmentObject var appState: AppState
    @StateObject private var mapVM = WorldMapViewModel()

    var body: some View {
        Group {
            #if os(macOS)
            macLayout
            #else
            iosLayout
            #endif
        }
        .onReceive(NotificationCenter.default.publisher(for: .zlJumpToCharacter)) { _ in
            mapVM.visit(.letterHouse)
        }
    }

    #if os(iOS)
    private var iosLayout: some View {
        NavigationStack {
            WorldMapView(mapVM: mapVM)
        }
    }
    #endif

    #if os(macOS)
    private var macLayout: some View {
        NavigationSplitView {
            List {
                Section(avatarStore.avatar?.name ?? "Zoya") {
                    ForEach(MapLocation.allCases) { location in
                        Label(location.title, systemImage: "mappin.circle.fill")
                            .foregroundStyle(mapVM.isUnlocked(location) ? ZLTheme.ink : .secondary)
                    }
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("Neighborhood")
            .navigationSplitViewColumnWidth(min: 200, ideal: 220, max: 260)
        } detail: {
            NavigationStack {
                WorldMapView(mapVM: mapVM)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationSplitViewStyle(.balanced)
        .frame(minWidth: 900, minHeight: 650)
    }
    #endif
}
