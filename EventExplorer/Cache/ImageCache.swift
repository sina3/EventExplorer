//
//  ImageCache.swift
//  EventExplorer
//
//  Created by Sina Rezazadeh on 2026-08-20.
//

import UIKit

actor ImageCache {
    static let shared = ImageCache()

    private let cache = NSCache<NSString, UIImage>()

    func image(for url: URL) async -> UIImage? {
        let key = url.absoluteString as NSString
        if let cached = cache.object(forKey: key) {
            return cached
        }

        guard let (data, response) = try? await URLSession.shared.data(from: url),
              let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200,
              let image = UIImage(data: data) else {
            return nil
        }

        cache.setObject(image, forKey: key)
        return image
    }
}
