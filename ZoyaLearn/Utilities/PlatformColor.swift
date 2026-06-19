//
//  PlatformColor.swift
//  ZoyaLearn
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

enum ZLPlatformColor {
    static var cardBackground: Color {
        #if os(iOS)
        Color(uiColor: .secondarySystemGroupedBackground)
        #else
        Color(nsColor: .controlBackgroundColor)
        #endif
    }

    static var groupedBackground: Color {
        #if os(iOS)
        Color(uiColor: .systemGroupedBackground)
        #else
        Color(nsColor: .windowBackgroundColor)
        #endif
    }
}

/// Cross-platform toolbar placements (topBarLeading/Trailing are iOS-only).
enum ZLToolbar {
    static var leading: ToolbarItemPlacement {
        #if os(iOS)
        .topBarLeading
        #else
        .navigation
        #endif
    }

    static var trailing: ToolbarItemPlacement {
        #if os(iOS)
        .topBarTrailing
        #else
        .primaryAction
        #endif
    }
}
