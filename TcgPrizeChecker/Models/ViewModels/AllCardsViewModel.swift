//
//  AllCardsViewModel.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 14/12/2024.
//

import SwiftUI
import SwiftData

class AllCardsViewModel: ObservableObject {
	@Environment(\.modelContext) private var modelContext
	
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
	
	func fetchCardDetails(cardID: String) async throws -> Card {
		return try await dataService.fetchDetailedCard(cardID: cardID)
	}
	
	func downloadImage(from urlString: String) async throws -> Data {
		guard let url = URL(string: urlString) else {
			throw DataServiceError.invalidURL
		}
		let (data, _) = try await URLSession.shared.data(from: url)
		return data
	}
	
	@MainActor
	func saveImageToSwiftDataVM(modelContext: ModelContext, imageData: Data, id: String, localId: String, name: String, cardToSave: String, deckName: String, selectedDeckID: String, selectedDeck: Deck) {
		
		dataService.saveImageToSwiftDataDS(
			modelContext: modelContext,
			imageData: imageData,
			id: id,
			localId: localId,
			name: name,
			cardToSave: cardToSave,
			deckName: deckName,
			selectedDeckID: selectedDeckID,
			selectedDeck: selectedDeck
		)
	}
}


