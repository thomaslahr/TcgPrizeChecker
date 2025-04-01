//
//  CachedImageView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 01/04/2025.
//

import SwiftUI

class ImageCache {
	static let shared = NSCache<NSString, UIImage>()
}

struct CachedImageView: View {
	let urlString: String
	@State private var uiImage: UIImage?

	var body: some View {
		Group {
			if let image = uiImage {
				Image(uiImage: image)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(maxWidth: 60)
					.shadow(color: .black, radius: 3)
			} else {
				Image("cardBackMedium")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(maxWidth: 60)
					.onAppear {
						loadImage()
					}
			}
		}
	}

	private func loadImage() {
		if let cachedImage = ImageCache.shared.object(forKey: urlString as NSString) {
			uiImage = cachedImage
			return
		}

		guard let url = URL(string: urlString) else { return }

		Task {
			do {
				let (data, _) = try await URLSession.shared.data(from: url)
				if let image = UIImage(data: data) {
					ImageCache.shared.setObject(image, forKey: urlString as NSString)

					await MainActor.run {
						uiImage = image
					}
				}
			} catch {
				print("Image loading failed: \(error)")
			}
		}
	}
}



#Preview {
	CachedImageView(urlString: "")
}
