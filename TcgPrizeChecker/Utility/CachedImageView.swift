//
//  CachedImageView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 01/04/2025.
//

import SwiftUI

//class ImageCache {
//	static let shared = ImageCache()
//	private let cache = NSCache<NSString, UIImage>()
//	private var cacheSize: Int = 0  // Track total cache size in bytes
//
//	func setObject(_ image: UIImage, forKey key: String) {
//		let dataSize = image.jpegData(compressionQuality: 1.0)?.count ?? 0
//		cache.setObject(image, forKey: key as NSString, cost: dataSize)
//		cacheSize += dataSize  // Keep track of total size
//
//		print("🖼️ Caching image: \(key) | Size: \(formatSize(dataSize)) MB")
//		printCacheStatus()
//	}
//
//	func object(forKey key: String) -> UIImage? {
//		let image = cache.object(forKey: key as NSString)
//		if image != nil {
//			print("✅ Loaded from cache: \(key)")
//		} else {
//			print("❌ Not found in cache: \(key)")
//		}
//		return image
//	}
//
//	func printCacheStatus() {
//		let totalSizeMB = formatSize(cacheSize)
//		let itemCount = cache.countLimit  // CountLimit isn't always accurate, but gives an idea
//		print("🗂️ Cache contains ~\(totalSizeMB) MB, Number of stored items: \(itemCount)")
//	}
//
//
//
//	private func formatSize(_ bytes: Int) -> String {
//		let mb = Double(bytes) / (1024 * 1024)
//		return String(format: "%.2f", mb)
//	}
//
//
//}



struct CachedImageView: View {
	let urlString: String
	@State private var uiImage: UIImage?
	
	var body: some View {
		Group {
			if let image = uiImage {
				Image(uiImage: image)
					.resizable()
					.aspectRatio(contentMode: .fit)
				//.frame(maxWidth: 60)
					.shadow(color: .black, radius: 3)
			} else {
				Image(.cardBackMedium)
					.resizable()
					.aspectRatio(contentMode: .fit)
				//.frame(maxWidth: 60)
					.shadow(color: .black, radius: 3)					.onAppear {
						loadImage()
					}
			}
		}
	}
	
	private func loadImage() {
		// 1️⃣ Check if image exists in FileManager
		if let cachedImage = PersistentImageCache.shared.getImage(forKey: urlString) {
			uiImage = cachedImage
			return
		}
		
		// 2️⃣ Download from network if not cached
		guard let url = URL(string: urlString) else {
			print("🚨 Invalid URL: \(urlString)")
			return
		}
		
		print("🌍 Downloading image: \(urlString)")
		
		Task {
			do {
				let (data, _) = try await URLSession.shared.data(from: url)
				if let image = decodeImageWithAlpha(from: data) {
					PersistentImageCache.shared.saveImage(image, forKey: urlString)
					
					await MainActor.run {
						uiImage = image
					}
				}
			} catch {
				print("❌ Image download failed: \(error)")
			}
		}
	}
	
	private func decodeImageWithAlpha(from data: Data) -> UIImage? {
		guard let source = CGImageSourceCreateWithData(data as CFData, nil),
			  let cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil) else {
			return nil
		}
		return UIImage(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .up)
	}
	
}



#Preview {
	CachedImageView(urlString: "")
}
