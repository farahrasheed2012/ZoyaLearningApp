//
//  GamesHubView.swift
//  ZoyaLearn
//

import SwiftUI

struct GamesHubView: View {
    var body: some View {
        List {
            Section("Mini Games") {
                NavigationLink("Match It") { MatchItGameView() }
                NavigationLink("Find It") { FindItGameView() }
                NavigationLink("Fill in the Blank") { FillBlankGameView() }
            }
        }
        #if os(iOS)
        .listStyle(.insetGrouped)
        #endif
        .navigationTitle("Games")
        .largeNavTitle()
    }
}
