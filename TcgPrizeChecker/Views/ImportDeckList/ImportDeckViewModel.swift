//
//  ImportDeckViewModel.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 09/05/2025.
//

import Foundation

@MainActor
class ImportDeckViewModel: ObservableObject {
	@Published var matchedCards: [MatchedCard] = []
	@Published var isLoading = false
	@Published var currentFetchIndex: Int = 0
	@Published var totalCardsToFetch: Int = 0
	
	let dataService = DataService()
	
	var totalFetchedCardCount: Int {
		matchedCards.reduce(0) { $0 + $1.quantity }
	}
	
	@MainActor
	func matchAndFetchDetailedCards(from parsedCards: [ParsedCardLine]) async {
		isLoading = true
		defer { isLoading = false }

		do {
			let allCards = try await dataService.fetchAllCards()
			let filteredCards = allCards.filter { $0.id.lowercased().hasPrefix("sv") }
			
			var initialMatched: [MatchedCard] = []

			for parsed in parsedCards {
				let formattedLocalId = parsed.localId

				if let energyType = EnergyType.allCases.first(where: { $0.name.caseInsensitiveCompare(parsed.name) == .orderedSame }) {
					let energyCard = createLocalEnergyCard(for: energyType)
					initialMatched.append(MatchedCard(quantity: parsed.quantity, card: energyCard))
					continue
				}

				if let match = filteredCards.first(where: {
					$0.name.localizedCaseInsensitiveCompare(parsed.name) == .orderedSame &&
					$0.localId == formattedLocalId
				}) {
					// ✅ Apply quantity limit for non-energy cards here
					let isEnergy = match.category == "Energy"
					let cappedQuantity = isEnergy ? parsed.quantity : min(parsed.quantity, 4)
					initialMatched.append(MatchedCard(quantity: cappedQuantity, card: match))
				} else {
					print("No match for \(parsed.name) [\(formattedLocalId)]")
				}
			}

			// ✅ Now this reflects the correctly capped quantities
			self.totalCardsToFetch = initialMatched.reduce(0) { $0 + $1.quantity }
			self.currentFetchIndex = 0
			self.matchedCards = []

			var detailedResults: [MatchedCard] = []

			for matched in initialMatched {
				if matched.card.category == "Energy" {
					detailedResults.append(matched)
					await MainActor.run {
						self.currentFetchIndex += matched.quantity
					}
					continue
				}

				do {
					let detailedCard = try await dataService.fetchDetailedCard(cardID: matched.card.id)
					detailedResults.append(MatchedCard(quantity: matched.quantity, card: detailedCard))
				} catch {
					print("Failed to fetch detailed data for \(matched.card.id): \(error)")
				}

				await MainActor.run {
					self.currentFetchIndex += matched.quantity
				}
			}

			self.matchedCards = detailedResults

		} catch {
			print("❌ Error fetching cards: \(error)")
		}
	}



	
	func createPersistentCards(from matchedCards: [MatchedCard]) async throws -> [PersistentCard] {
		var persistentCards: [PersistentCard] = []

		for matched in matchedCards {
			
			var imageData: Data
			
			if let energyCard = EnergyType.allCases.first(where: { $0.name == matched.card.name }) {
				// Energy card handling
				guard let image = energyCard.energyCardUIImage,
					  let imageDataFromEnergy = image.pngData() else {
					print("No image found for energy card: \(matched.card.name)")
					continue
				}
				imageData = imageDataFromEnergy
				print("Using local image for energy card: \(matched.card.name)")
			} else {
				// Non-energy card handling
				if let imageUrl = matched.card.image,
				   let imageDataFromURL = try? await dataService.downloadImage(from: "\(imageUrl)/high.webp") {
					imageData = imageDataFromURL
					print("Downloading image from: \(imageUrl)")
					print("Downloaded image size: \(imageData.count) bytes")
				} else {
					print("No image URL or failed to fetch for card: \(matched.card.name)")
					continue // Skip if image can't be fetched
				}
			}

			// Add the card to the persistent list
			for _ in 0..<matched.quantity {
				let persistentCard = PersistentCard(
					imageData: imageData,
					id: matched.card.id,
					localId: matched.card.localId,
					name: matched.card.name,
					uniqueId: UUID().uuidString, // NEW UUID for each
					category: matched.card.category,
					trainerType: matched.card.trainerType,
					stage: matched.card.stage,
					evolveFrom: matched.card.evolveFrom
				)
				persistentCards.append(persistentCard)
			}
		}
		return persistentCards
	}

	
	private func createLocalEnergyCard(for type: EnergyType) -> Card {
		return Card(
			image: nil,
			id: UUID().uuidString,
			localId: "",
			name: type.name,
			category: "Energy",
			trainerType: nil,
			stage: nil,
			evolveFrom: nil
		)
	}
}
