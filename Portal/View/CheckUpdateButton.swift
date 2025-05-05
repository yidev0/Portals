//
//  CheckUpdateButton.swift
//  Portals
//
//  Created by Yuto on 2025/05/05.
//

import SwiftUI
import Sparkle

struct CheckUpdateButton: View {
    
    @State var showUpdateLabel: Bool = false
    private let updaterController: SPUStandardUpdaterController
    
    init() {
        updaterController = SPUStandardUpdaterController(
            startingUpdater: true,
            updaterDelegate: nil,
            userDriverDelegate: nil
        )
    }
    
    var body: some View {
        Button {
            updaterController.updater.checkForUpdates()
        } label: {
            Text("Check for Updates")
                .foregroundStyle(.secondary)
                .opacity(showUpdateLabel ? 1 : 0)
            Image(systemName: "circle.fill")
        }
        .buttonStyle(.borderless)
        .onHover { hovering in
            showUpdateLabel = hovering
        }
    }
}

#Preview {
    CheckUpdateButton()
}
