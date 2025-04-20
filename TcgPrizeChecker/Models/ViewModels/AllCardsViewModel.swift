//
//  AllCardsViewModel.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 14/12/2024.
//

import SwiftUI
import SwiftData

class AllCardsViewModel: ObservableObject {
	
	private let dataService = DataService()
	
	@Published var cards: [Card] = []
	@Published var name: CardSetName?
	
	var cardLookup: [String: Card] {
		Dictionary(uniqueKeysWithValues: cards.map { ($0.id, $0) })
	}
	@MainActor
	func fetchAllCards() async {
		do {
			let fetchAllCards = try await dataService.fetchAllCards()
			
			cards = fetchAllCards
		} catch {
			print("Error fetching all cards: \(error.localizedDescription)")
		}
	}
	
//	func fetchCardDetails(cardID: String) async throws -> Card {
//		return try await dataService.fetchDetailedCard(cardID: cardID)
//	}
	
	func downloadImage(from urlString: String) async throws -> Data {
		try await dataService.downloadImage(from: urlString)
	}
	
//	func downloadImage(from urlString: String) async throws -> Data {
//		guard let url = URL(string: urlString) else {
//			throw DataServiceError.invalidURL
//		}
//		let (data, _) = try await URLSession.shared.data(from: url)
//		return data
//	}
	
	@MainActor
	func saveImageToSwiftData(
		info: CardSaveInfo,
		modelContext: ModelContext
		
		//category: String
	) async {
		do {
			let detailedCard = try await dataService.fetchDetailedCard(cardID: info.card.id)
			
			//For every detailed added, they also needs to be added the following places:
			//Card, PersistentCard, PlayableCard
			//AddEnergyView, AddPlayableView, AllCardsViewModel,
			
			let category = detailedCard.category
			let trainerType = detailedCard.trainerType
			let stage = detailedCard.stage
			let evolveFrom = detailedCard.evolveFrom
		//	let types = detailedCard.types
			
			switch info.cardToSave {
			case .deck:
					let storedCard = PersistentCard(
						imageData: info.imageData ,
						id: info.card.id,
						localId: info.card.localId,
						name: info.card.name,
						uniqueId: UUID().uuidString,
						category: category,
						trainerType: trainerType,
						stage: stage,
						evolveFrom: evolveFrom
						//types: types
						
					)
					info.selectedDeck.cards.append(storedCard)
					modelContext.insert(storedCard)
			case .playable:
					let storedCard = PlayableCard(
						imageData: info.imageData,
						id: info.card.id,
						localId: info.card.localId,
						name: info.card.name,
						uniqueId: UUID().uuidString,
						category: category,
						trainerType: trainerType,
						stage: stage,
						evolveFrom: evolveFrom
						//types: types
					)
					modelContext.insert(storedCard)
			}
			try modelContext.save()
			print("✅ Card successfully saved to SwiftData")
		} catch {
			print("❌ Failed to save card with ID \(info.card.id): \(error.localizedDescription)")
		}
	}
	
	@MainActor
	func addCardToDeckOrPlayables(
		card: Card,
		cardSaveType: CardSaveType,
		selectedDeckID: String,
		deckName: String,
		selectedDeck: Deck?,
		cardsInDeck: [PersistentCard],
		playableCards: [PlayableCard],
		modelContext: ModelContext
	) async throws -> String {
		
		let copiesOfCardInDeck = cardsInDeck.filter { $0.id == card.id }.count
		let copiesOfCardInPlayables = playableCards.filter { $0.id == card.id }.count
		
		switch cardSaveType {
		case .deck:
			if selectedDeck?.cards.count ?? 0 > 70 {
				throw ValidationError.deckTooFull(deckName: selectedDeck?.name ?? "")
			}
			if copiesOfCardInDeck >= 4 {
				throw ValidationError.tooManyCopiesInDeck
			}
		case .playable:
			if copiesOfCardInPlayables >= 1 {
				throw ValidationError.alreadyInPlayables
			}
		}
		
		let imageURL = "\(card.image ?? "")/high.webp"
		let imageData = try await downloadImage(from: imageURL)
		
		let info = CardSaveInfo(
			imageData: imageData,
			card: card,
			cardToSave: cardSaveType,
			deckName: deckName,
			selectedDeckID: selectedDeckID,
			selectedDeck: selectedDeck ?? Deck(name: "Not a deck")
		)
		
		await saveImageToSwiftData(info: info, modelContext: modelContext)
		
		switch cardSaveType {
		case .deck:
			return "\(card.name) was added to the \(deckName) deck. (\(copiesOfCardInDeck + 1)/4)"
		case .playable:
			return "\(card.name) was added as a playable card."
		}
	}
}

enum CardSaveType: String {
	case deck = "Deck"
	case playable = "Playable"
}

enum ValidationError: LocalizedError {
	case deckTooFull(deckName: String)
	case tooManyCopiesInDeck
	case alreadyInPlayables
	
	var errorDescription: String? {
		switch self {
		case .deckTooFull(let deckName):
			return "You can't add any more cards to the deck. The card was not added to \(deckName)."
		case .tooManyCopiesInDeck:
			return "You can't have more than 4 copies of a card in a deck."
		case .alreadyInPlayables:
			return "There already is a copy of this card in Playables. It was not added again."
		}
	}
}
