//
//  DeckViewModel.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 13/04/2025.
//

import SwiftUI

class DeckViewModel: ObservableObject {
	@Published var isLoadingDeck = false
	@Published var readyDeckID: String? = nil
	@Published var lastRenderedDeckID: String?
	@Published var cardSortOrder = CardSortOrder.dateAdded
	
	private var imageCache: ImageCacheViewModel
	
	init(imageCache: ImageCacheViewModel) {
		self.imageCache = imageCache
	}
	
	@MainActor
	func preloadImages(for deck: Deck) async {
		for card in deck.cards {
			// Skip if already cached
			if imageCache.cache[card.uniqueId] != nil {
				continue
			}
			
			let imageData = card.imageData
			let cardID = card.uniqueId
			// Load and downscale on a background thread
			await Task.detached(priority: .utility) {
				guard let image = UIImage(data: imageData) else { return }
				let targetSize = CGSize(width: 140, height: 200)
				guard let downscaled = image.downscaled(to: targetSize) else { return }
				
				await MainActor.run {
					self.imageCache.setImage(downscaled, for: cardID)
				}
			}.value // Wait for the detached task to finish before continuing
		}
	}
	
	func isDeckCached(_ deck: Deck) -> Bool {
		deck.cards.allSatisfy { imageCache.cache[$0.uniqueId] != nil }
	}
	
	func sortedCards(for deck: Deck) -> [PersistentCard] {
		switch cardSortOrder {
		case .dateAdded:
			return deck.cards.sorted { $0.dateAdded < $1.dateAdded }
		case .alphabetical:
			return deck.cards.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
		}
	}
	
}
