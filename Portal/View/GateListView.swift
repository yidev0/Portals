//
//  GateListView.swift
//  Portals
//
//  Created by Yuto on 2025/04/23.
//

import SwiftUI
import SwiftData

struct GateListView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var gates: [Gate]
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(gates) { gate in
                        GateCell(gate: gate)
                            .listRowInsets(
                                .init(
                                    top: 6,
                                    leading: 2,
                                    bottom: 6,
                                    trailing: 0
                                )
                            )
                    }
                    .onDelete(perform: deleteItems)
                    .alignmentGuide(.listRowSeparatorLeading) { _ in
                        0
                    }
                }
                
                Section {
                    GateCreateCell()
                        .padding(.top, 4)
                        .padding(.bottom, 2)
                }
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .listRowSeparatorTint(Color(.separatorColor))
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(gates[index])
            }
        }
    }
}

#Preview {
    GateListView()
}
