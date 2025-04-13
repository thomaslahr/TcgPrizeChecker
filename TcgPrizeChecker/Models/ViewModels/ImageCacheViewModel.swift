//
//  ImageCacheViewModel.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 11/04/2025.
//

import SwiftUI
import UIKit

class ImageCacheViewModel: ObservableObject {
	@Published var cache: [String: UIImage] = [:]
	@Published var revealedCardIDs: Set<String> = []
	
	private var insertionOrder: [String] = []
	private let maxCacheSize = 180
	
	func setImage(_ image: UIImage, for key: String) {
		//Avoid re-caching existing images
		guard cache[key] == nil else { return }
		
		cache[key] = image
		insertionOrder.append(key)
		
		if insertionOrder.count > maxCacheSize {
			let overflow = insertionOrder.count - maxCacheSize
			let keysToRemove = insertionOrder.prefix(overflow)
			
			for key in keysToRemove {
				cache.removeValue(forKey: key)
			}
			insertionOrder.removeFirst(overflow)
			print("Card removed from cache")
		}
	}
	
	func isReady(for deck: Deck) -> Bool {
		for card in deck.cards {
			if cache[card.uniqueId] == nil {
				return false
			}
		}
		return true
	}
	
	func revealCard(_ card: PersistentCard) {
		guard !revealedCardIDs.contains(card.uniqueId) else { return }

		let delay = Double(abs(card.uniqueId.hashValue % 10)) * 0.03

		DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
			withAnimation(.easeIn(duration: 0.25)) {
				_ = self.revealedCardIDs.insert(card.uniqueId)
			}
		}
	}
}

extension UIImage {
	func downscaled(to size: CGSize) -> UIImage? {
		let format = UIGraphicsImageRendererFormat.default()
		format.scale = 1  // Prevents Retina scaling from bloating memory
		let renderer = UIGraphicsImageRenderer(size: size, format: format)
		return renderer.image { _ in
			self.draw(in: CGRect(origin: .zero, size: size))
		}
	}
}
