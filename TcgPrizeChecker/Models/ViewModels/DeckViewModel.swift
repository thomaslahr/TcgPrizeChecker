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
		
		let copyCounts = Dictionary(grouping: deck.cards, by: { $0.name }).mapValues { $0.count }
		
		switch cardSortOrder {
		case .dateAdded:
			return deck.cards.sorted { $0.dateAdded < $1.dateAdded }
		case .alphabetical:
			return deck.cards.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
		case .standard:
			return deck.cards.sorted { lhs, rhs in
						// 1. Category Priority
						let lhsCat = categoryPriority(lhs.category)
						let rhsCat = categoryPriority(rhs.category)
						if lhsCat != rhsCat {
							return lhsCat < rhsCat
						}

						// 2. TrainerType Priority (if category is Trainer)
						if lhs.category == "Trainer", rhs.category == "Trainer" {
							let lhsTrainer = trainerTypePriority(lhs.trainerType)
							let rhsTrainer = trainerTypePriority(rhs.trainerType)
							if lhsTrainer != rhsTrainer {
								return lhsTrainer < rhsTrainer
							}
						}
				if lhs.category == "Pokemon", rhs.category == "Pokemon" {
					if lhs.evolveFrom == rhs.name {
						return false
					}
					
					if rhs.evolveFrom == lhs.name {
						return true
					}
				}
						// 4. Copy Count (higher count comes first)
						let lhsCopies = copyCounts[lhs.name] ?? 0
						let rhsCopies = copyCounts[rhs.name] ?? 0
						if lhsCopies != rhsCopies {
							return lhsCopies > rhsCopies
						}

						// 4. Fallback: Date added (older first)
						return lhs.id < rhs.id
					}
		}
	}
	
	private func categoryPriority(_ category: String?) -> Int {
		switch category {
		case "Pokemon":
			return 0
		case "Trainer":
			return 1
		case "Energy":
			return 2
		default:
			return 3 // Unknown or nil category goes last
		}
	}
	
	private func trainerTypePriority(_ type: String?) -> Int {
		switch type {
		case "Supporter": return 0
		case "Item":      return 1
		case "Tool":      return 2
		case "Stadium":   return 3
		default:          return 4
		}
	}
}
