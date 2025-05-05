//
//  ContentView.swift
//  Portal
//
//  Created by Yuto on 2025/04/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    var body: some View {
        GateListView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Gate.self, inMemory: true)
}
