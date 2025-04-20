//
//  CardSetViewModel.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 01/11/2024.
//

//import SwiftUI
//import SwiftData
//
//class CardSetViewModel: ObservableObject {
//	@Environment(\.modelContext) private var modelContext
//	private let dataService = DataService()
//	
//	@Published var cards: [Card] = []
//	//	@Published var id = ""
//	//	@Published var image = ""
//	//	@Published var localId = ""
//	@Published var name: CardSetName?
//	
//	@MainActor
//	func fetchCardSet(cardSetNumber: String) async {
//		do {
//			let fetchedcardSet = try await dataService.fetchCardSet(cardSetNumber: cardSetNumber)
//			
//			cards = fetchedcardSet.cards
//			name = fetchedcardSet.name
//			
//		} catch {
//			print("Error fetching card set: \(error.localizedDescription)")
//		}
//	}
//
//	func downloadImage(from urlString: String) async throws -> Data {
//		guard let url = URL(string: urlString) else {
//			throw DataServiceError.invalidURL
//		}
//		let (data, _) = try await URLSession.shared.data(from: url)
//		return data
//	}
//	
//	@MainActor
//	func saveImageToSwiftDataVM(modelContext: ModelContext, imageData: Data, id: String, localId: String, name: String, cardToSave: String, deckName: String) {
//		
//		dataService.saveImageToSwiftDataDS(
//			modelContext: modelContext,
//			imageData: imageData,
//			id: id,
//			localId: localId,
//			name: name,
//			cardToSave: cardToSave,
//			deckName: deckNam
//		)
//	}
//	
//	static let sampleData = CardSetViewModel()
//}
//
//enum CardSetError: Error {
//	case invalidURL
//	case downloadFailed
//}
