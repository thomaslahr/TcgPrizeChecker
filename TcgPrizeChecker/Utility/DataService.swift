//
//  DataService.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 29/10/2024.
//

import SwiftUI
import SwiftData

struct DataService {
	//@Environment(\.modelContext) private var modelContext
	
	private func fetchData<T: Decodable>(from urlString: String, as type: T.Type) async throws -> T {
		guard let url = URL(string: urlString) else {
			throw DataServiceError.invalidURL
		}
		
		let (data, _) = try await URLSession.shared.data(from: url)
		return try JSONDecoder().decode(T.self, from: data)
	}
//	func fetchCardSet(cardSetNumber: String) async throws -> CardSet {
//		let urlString = "https://api.tcgdex.net/v2/en/sets/\(cardSetNumber)"
//		return try await fetchData(from: urlString, as: CardSet.self)
//	}
	
	
	func fetchDetailedCard(cardID: String) async throws -> Card {
		let urlString = "https://api.tcgdex.net/v2/en/cards/\(cardID)"
		print("We're in the fetch function in DataService, url: \(urlString)")
		return try await fetchData(from: urlString, as: Card.self)
	}
	
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
}

enum DataServiceError: Error {
	case invalidURL
	case noDataRecieved
}


//private func fetchData<T: Decodable>(from urlString: String, as type: T.Type) async throws -> T {
//	guard let url = URL(string: urlString) else {
//		throw DataServiceError.invalidURL
//	}
//
//	let (data, response) = try await URLSession.shared.data(from: url)
//
//	// Optional: Try logging the HTTP status
//	if let httpResponse = response as? HTTPURLResponse {
//		print("Status code: \(httpResponse.statusCode)")
//	}
//
//	// Optional: Pretty print the JSON response for debugging
//	if let jsonString = String(data: data, encoding: .utf8) {
//		print("Raw JSON from \(urlString):\n\(jsonString)")
//	}
//
//	do {
//		return try JSONDecoder().decode(T.self, from: data)
//	} catch {
//		print("Decoding error from URL: \(urlString)")
//		print("Decoding failed with error: \(error)")
//		throw error
//	}
//}
