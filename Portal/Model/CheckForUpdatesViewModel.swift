//
//  CheckForUpdatesViewModel.swift
//  Portals
//
//  Created by Yuto on 2025/05/05.
//

import Foundation
import SwiftUI
import Sparkle

final class CheckForUpdatesViewModel: ObservableObject {
    @Published var canCheckForUpdates = false

    init(updater: SPUUpdater) {
        updater.publisher(for: \.canCheckForUpdates)
            .assign(to: &$canCheckForUpdates)
    }
}
