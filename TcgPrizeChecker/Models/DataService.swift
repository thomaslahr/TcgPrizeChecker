//
//  DataService.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 29/10/2024.
//

import SwiftUI
import SwiftData

struct DataService {
	@Environment(\.modelContext) private var modelContext
	
	private func fetchData<T: Decodable>(from urlString: String, as type: T.Type) async throws -> T {
		guard let url = URL(string: urlString) else {
			throw DataServiceError.invalidURL
		}
		
		let (data, _) = try await URLSession.shared.data(from: url)
		return try JSONDecoder().decode(T.self, from: data)
	}
	func fetchCardSet(cardSetNumber: String) async throws -> CardSet {
		let urlString = "https://api.tcgdex.net/v2/en/sets/\(cardSetNumber)"
		return try await fetchData(from: urlString, as: CardSet.self)
	}
	
	
//	func fetchCard(cardSetNumber: String, cardNumber: String) async throws -> Card {
//		let urlString = "https://api.tcgdex.net/v2/en/cards/\(cardSetNumber)-\(cardNumber)"
//		print("We're in the fetch function in DataService.")
//		return try await fetchData(from: urlString, as: Card.self)
//	}
	
	func fetchAllCards() async throws -> [Card] {
		let urlString = "https://api.tcgdex.net/v2/en/cards"
		return try await fetchData(from: urlString, as: [Card].self)
	}
	
	
	func downloadImage(from urlString: String) async throws -> Data {
		guard let url = URL(string: urlString) else {
			throw DataServiceError.invalidURL
		}
		let (data, _) = try await URLSession.shared.data(from: url)
		return data
	}
	
	func saveImageToSwiftDataDS(modelContext: ModelContext, imageData: Data, id: String, localId: String, name: String, cardToSave: String, deckName: String, selectedDeckID: String, selectedDeck: Deck) {
			do {
				if cardToSave == "Deck" {
					let storedCard = PersistentCard(
						imageData: imageData ,
						id: id,
						localId: localId,
						name: name,
						uniqueId: UUID().uuidString
					)
					selectedDeck.cards.append(storedCard)
					modelContext.insert(storedCard)
					try modelContext.save()
					print("Card successfully saved to SwiftData with a deck name of \(deckName). (Not saved to a deck object.)")
					print("ID: \(selectedDeckID)")
				} else {
					let storedCard = PlayableCard(imageData: imageData, id: id, localId: localId, name: name, uniqueId: UUID().uuidString)
					modelContext.insert(storedCard)
					try modelContext.save()
					print("Card successfully saved to SwiftData as a Playable Card.")
					
				}
			} catch {
				print("Error saving the card to SwiftData: \(error.localizedDescription)")
			}
	}
}

enum DataServiceError: Error {
	case invalidURL
	case noDataRecieved
}
