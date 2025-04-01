//
//  PersistentImageCache.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 01/04/2025.
//

import SwiftUI

import SwiftUI

class PersistentImageCache {
	static let shared = PersistentImageCache()
	private let fileManager = FileManager.default
	private let cacheDirectory: URL

	private init() {
		cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
	}

	/// Returns the file URL for a given image key (URL string)
	private func fileURL(forKey key: String) -> URL {
		let filename = key.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? key
		return cacheDirectory.appendingPathComponent(filename)
	}

	/// Fetches an image from disk if available
	func getImage(forKey key: String) -> UIImage? {
		let fileURL = fileURL(forKey: key)
		guard fileManager.fileExists(atPath: fileURL.path),
			  let data = try? Data(contentsOf: fileURL),
			  let image = UIImage(data: data) else { return nil }
		return image
	}

	/// Saves an image to disk
	func saveImage(_ image: UIImage, forKey key: String) {
		let fileURL = fileURL(forKey: key)
		if let data = image.jpegData(compressionQuality: 0.8) {
			try? data.write(to: fileURL, options: .atomic)
		}
	}
}

