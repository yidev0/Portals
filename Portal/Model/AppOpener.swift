//
//  AppOpener.swift
//  Portals
//
//  Created by Yuto on 2025/04/23.
//

import Foundation
import AppKit
import SwiftUI

struct AppOption {
    let name: String
    let url: URL
    let identifier: String
    
    func makeButton() -> some View {
        Button {
            NSWorkspace.shared.open([url], withApplicationAt: url, configuration: .init())
        } label: {
            Text(name)
        }
    }
}

struct AppOpener {
    
    func getBrowsers() -> [AppOption] {
        if let url = URL(string: "https://github.com") {
            let apps = NSWorkspace.shared.urlsForApplications(toOpen: url)
            return apps.compactMap { url in
                if let bundle = Bundle(url: url) {
                    let appName = bundle.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "Unknown"
                    let identifier = bundle.bundleIdentifier ?? "Unknown"
                    return .init(
                        name: appName,
                        url: url,
                        identifier: identifier
                    )
                }
                return nil
            }
        }
        return []
    }
    
    func open(url: URL) {
        guard let host = url.host() else { return }
        let workspace = NSWorkspace.shared
        
        if host.contains("zoom.us"), let _ = workspace.urlForApplication(withBundleIdentifier: "us.zoom.xos"){
            if let finalURL = URL(string: url.absoluteString
                .replacingOccurrences(of: "https://", with: "zoommtg://")
                .replacingOccurrences(of: "j/", with: "join?confno=")
                .replacingOccurrences(of: "?pwd=", with: "&pwd=")
            ) {
                workspace.open(finalURL)
            } else {
                workspace.open(url)
            }
        } else {
            workspace.open(url)
        }
    }
    
}
