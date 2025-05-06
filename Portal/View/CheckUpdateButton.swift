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
    @ObservedObject private var checkForUpdatesViewModel: CheckForUpdatesViewModel
    
    private let updaterController: SPUStandardUpdaterController
    
    init() {
        updaterController = SPUStandardUpdaterController(
            startingUpdater: true,
            updaterDelegate: nil,
            userDriverDelegate: nil
        )
        checkForUpdatesViewModel = CheckForUpdatesViewModel(
            updater: updaterController.updater
        )
    }
    
    var body: some View {
        Button {
            updaterController.updater.checkForUpdates()
        } label: {
            Text("Check for Updates")
                .opacity(showUpdateLabel ? 1 : 0)
            Image(systemName: "circle.fill")
                .resizable()
                .frame(width: 10, height: 10)
                .foregroundStyle(.secondary)
        }
        .buttonStyle(.borderless)
        .buttonBorderShape(.buttonBorder)
        .onHover { hovering in
            showUpdateLabel = hovering
        }
    }
}

#Preview {
    CheckUpdateButton()
}
