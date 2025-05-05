//
//  PortalApp.swift
//  Portal
//
//  Created by Yuto on 2025/04/23.
//

import SwiftUI
import SwiftData

@main
struct PortalApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Gate.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @State var isPresented: Bool = false

    var body: some Scene {
        MenuBarExtra {
            ContentView()
                .modelContainer(sharedModelContainer)
                .onAppear {
                    isPresented = true
                }
                .onDisappear {
                    isPresented = false
                }
                .environment(\.openURL, OpenURLAction { url in
                    AppOpener().open(url: url)
                    return .handled
                })
        } label: {
            Image(systemName: "door.left.hand.\(isPresented ? "open" : "closed")")
        }
        .menuBarExtraStyle(.window)
    }
}
