//
//  ImageCache.swift
//  NexFlix
//
//  Created by Himanshu Dev on 02/01/26.
//

import UIKit

final class ImageCache {
    static let shared = NSCache<NSURL, UIImage>()
    private init() {}
}
