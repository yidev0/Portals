//
//  LinkLoader.swift
//  Bookmarks
//
//  Created by Yuto on 2024/10/26.
//

import Foundation

struct MetadataLoader {

    func fetchMetadata(from url: URL) async throws -> Data? {
        var request = URLRequest(url: url)
        request.setValue("Mozilla/5.0 (compatible; MetadataFetcher/1.0)", forHTTPHeaderField: "User-Agent")
        
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw error
        }
        
        if let httpResponse = response as? HTTPURLResponse,
            let finalURL = httpResponse.url,
            let htmlString = String(data: data, encoding: .utf8)  {
            let faviconURL = extractFavicon(from: htmlString, baseURL: finalURL)
            
            async let faviconData = fetchImageData(from: faviconURL)
            return try await faviconData
        }
        
        return nil
    }

    private func extractFavicon(from html: String, baseURL: URL) -> URL? {
        let linkRegex = try? NSRegularExpression(
            pattern: "<link[^>]*rel=[\"']icon[\"'][^>]*href=[\"'](.*?)[\"']",
            options: .caseInsensitive
        )
        let range = NSRange(html.startIndex..<html.endIndex, in: html)
        if let match = linkRegex?.firstMatch(in: html, options: [], range: range),
           let hrefRange = Range(match.range(at: 1), in: html),
           html[hrefRange].contains(".png") || html[hrefRange].contains(".ico") {
            return URL(string: String(html[hrefRange]), relativeTo: baseURL)
        }
        
        let siteBaseURL = URL(string: "\(baseURL.scheme!)://\(baseURL.host!)")!
        return siteBaseURL.appendingPathComponent("favicon.ico")
    }

    private func fetchImageData(from url: URL?) async throws -> Data? {
        guard let url = url else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            throw error
        }
    }
    
}
