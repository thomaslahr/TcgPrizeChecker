//
//  PersistentImageCache.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 01/04/2025.
//

import SwiftUI

class PersistentImageCache {
	static let shared = PersistentImageCache()
	private let fileManager = FileManager.default
	private let cacheDirectory: URL

	private init() {
		cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
		print("📂 Cache directory: \(cacheDirectory.path)") // This tells you where the files are stored
	}

	/// Returns the file path for a given image key (URL string)
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

		print("✅ Loaded from disk cache: \(fileURL.path)")
		return image
	}

	/// Saves an image to disk
	func saveImage(_ image: UIImage, forKey key: String) {
		let fileURL = fileURL(forKey: key)
		if let data = image.pngData() {
			do {
				try data.write(to: fileURL, options: .atomic)
				print("💾 Saved image to: \(fileURL.path)")
			} catch {
				print("❌ Failed to save image: \(error)")
			}
		}
	}

	/// Deletes a specific cached image
	func deleteImage(forKey key: String) {
		let fileURL = fileURL(forKey: key)
		if fileManager.fileExists(atPath: fileURL.path) {
			try? fileManager.removeItem(at: fileURL)
			print("🗑 Deleted cached image: \(fileURL.path)")
		}
	}

	/// Clears the entire cache
	func clearCache() {
		do {
			let files = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
			for file in files {
				try fileManager.removeItem(at: file)
			}
			print("🗑 Cleared all cached images.")
		} catch {
			print("❌ Error clearing cache: \(error)")
		}
	}
	
	/// Returns the total size of the cache in bytes
		func getCacheSizeInBytes() -> Int {
			do {
				let files = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
				let totalSize = files.reduce(0) { (result, fileURL) -> Int in
					let fileAttributes = try? fileManager.attributesOfItem(atPath: fileURL.path)
					let fileSize = fileAttributes?[.size] as? Int ?? 0
					return result + fileSize
				}
				return totalSize
			} catch {
				print("❌ Error calculating cache size: \(error)")
				return 0
			}
		}

		/// Returns the cache size in MB
		func getCacheSizeInMB() -> Int {
			return getCacheSizeInBytes() / (1024 * 1024)  // Convert bytes to MB
		}
}

