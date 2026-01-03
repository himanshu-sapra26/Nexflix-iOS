//
//  ImageLoader.swift
//  NexFlix
//
//  Created by Himanshu Dev on 02/01/26.
//

import Foundation
import UIKit

final class ImageLoader {
    static let shared = ImageLoader()

    func loadImage(from url: URL) async throws -> UIImage {
        // MARK: - Check cache first
        if let cached = ImageCache.shared.object(forKey: url as NSURL) {
            return cached
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw NSError(domain: "ImageLoader", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid image data"])
        }

        ImageCache.shared.setObject(image, forKey: url as NSURL)
        return image
    }
}
