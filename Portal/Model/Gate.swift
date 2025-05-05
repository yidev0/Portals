//
//  Item.swift
//  Portal
//
//  Created by Yuto on 2025/04/23.
//

import Foundation
import SwiftData

@Model
final class Gate {
    var name: String
    var url: URL
    var appIdentifier: String?
    var icon: Data?
    
    init(
        name: String,
        url: URL,
        identifier: String? = nil,
        icon: Data? = nil
    ) {
        self.name = name
        self.url = url
        self.appIdentifier = identifier
        self.icon = icon
    }
    
    func loadIcon() async {
        do {
            icon = try await MetadataLoader().fetchMetadata(from: url)
        } catch {
            print(error)
        }
    }
}
