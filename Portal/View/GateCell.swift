//
//  GateCell.swift
//  Portals
//
//  Created by Yuto on 2025/04/23.
//

import SwiftUI

struct GateCell: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.openURL) var openURL
    
    @State var showButton: Bool = false
    @State var gate: Gate
    @State var browserList: [AppOption] = []
    
    var body: some View {
        HStack {
            ZStack {
                if let data = gate.icon, let icon = NSImage(data: data) {
                    Image(nsImage: icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Image(systemName: "door.left.hand.closed")
                }
            }
            .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                TextField("Name", text: $gate.name)
                
                Text(gate.url.host() ?? gate.url.absoluteString)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            if showButton {
                Button {
                    let pasteBoard = NSPasteboard.general
                    pasteBoard.clearContents()
                    pasteBoard.writeObjects([gate.url as NSURL])
                    pasteBoard.setString(gate.url.absoluteString, forType: .string)
                } label: {
                    Image(systemName: "link")
                }
                .buttonStyle(.bordered)
                .accessibilityLabel("Copy Link")
                
                Menu {
                    ForEach(browserList, id: \.identifier) { browser in
                        browser.makeButton()
                    }
                } label: {
                    Text("Open")
                } primaryAction: {
                    openURL.callAsFunction(gate.url)
                }
                .aspectRatio(contentMode: .fit)
            } else {
                EmptyView()
            }
        }
        .onAppear {
            browserList = AppOpener().getBrowsers()
        }
        .onHover { hover in
            showButton = hover
        }
        .onSubmit {
            try? modelContext.save()
        }
    }
}

#Preview {
    GateCell(
        gate: .init(
            name: "Test",
            url: .init(string: "https://github.com")!
        )
    )
}
