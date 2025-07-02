//
//  GateCreateCell.swift
//  Portals
//
//  Created by Yuto on 2025/04/23.
//

import SwiftUI

struct GateCreateCell: View {
    
    @Environment(\.modelContext) private var modelContext

    @State var showNewItem: Bool = true
    
    @State var gateName = ""
    @State var gateURL = ""
    
    @State var showLabel: Bool = false
    @State var showFields: Bool = false
    
    var body: some View {
        ZStack {
            if showFields {
                createFields
            } else {
                button
            }
        }
        .onAppear {
            loadClipboard()
        }
        .onDisappear {
            showFields = false
        }
    }
    
    @ViewBuilder
    private var button: some View {
        HStack {
            Button {
                showFields = true
            } label: {
                Label {
                    Text("New Gate")
                        .opacity(showLabel ? 1 : 0)
                } icon: {
                    Image(systemName: "plus")
                }
            }
            .buttonStyle(.borderless)
            .onHover { hovering in
                showLabel = hovering
            }
            
            Spacer()
        }
        .animation(.default, value: showLabel)
    }
    
    @ViewBuilder
    private var createFields: some View {
        if showNewItem {
            VStack(spacing: 8) {
                LabeledContent {
                    TextField("Name", text: $gateName)
                } label: {
                    Image(systemName: "character.cursor.ibeam")
                }
                
                LabeledContent {
                    TextField("URL", text: $gateURL)
                } label: {
                    Image(systemName: "link")
                }
            }
            .textFieldStyle(.plain)
            .onSubmit {
                addGate()
            }
        } else {
            EmptyView()
        }
    }
    
    private func addGate() {
        Task {
            if let url = URL(string: gateURL) {
                let gate = Gate(name: gateName, url: url)
                await gate.loadIcon()
                modelContext.insert(gate)
                
                showFields = false
            }
        }
    }
    
    private func reset() {
        gateName = ""
        gateURL = ""
    }
    
    private func loadClipboard() {
        if NSPasteboard.general.types?.contains(.URL) == true {
            showNewItem = true
            let urls = NSPasteboard.general.readObjects(forClasses: [NSURL.self]) as? [URL]
            if let url = urls?.first {
                self.gateURL = url.absoluteString
            }
        } else if NSPasteboard.general.types?.contains(.string) == true {
            showNewItem = true
            let strings = NSPasteboard.general.readObjects(forClasses: [NSString.self]) as? [String] ?? []
            if let string = strings.first,
               URL(string: string) != nil && string.hasPrefix("http") {
                self.gateURL = string
            }
        }
    }
}

#Preview {
    GateCreateCell()
}
