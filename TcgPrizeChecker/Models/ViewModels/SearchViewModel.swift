//
//  SearchViewModel.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 09/04/2025.
//

import Combine
import Foundation

class SearchViewModel: ObservableObject {
	@Published var searchText = ""
	@Published var results: [Card] = []

	private var allCards: [Card] = []
	private var cancellables = Set<AnyCancellable>()
	
	var cardFilters = ["sv"]
	
	init(allCards: [Card]) {
		self.allCards = allCards
		
		$searchText
			.debounce(for: .milliseconds(500), scheduler: RunLoop.main)
			.removeDuplicates()
			.sink { [weak self] query in
				self?.performSearch(query: query)
			}
			.store(in: &cancellables)
	}
	
	func updateAllCards(_ newCards: [Card]) {
		allCards = newCards
		performSearch(query: searchText)
	}
	
	private func performSearch(query: String) {
			let lowercasedQuery = query.lowercased()
			
			guard !lowercasedQuery.isEmpty else {
				results = []
				return
			}
			
			// First, apply card filters (like "sv" ID matching)
			let filtered = allCards.filter { card in
				cardFilters.contains(where: { card.id.contains($0) })
			}
			
			// Then, apply name matching logic
			let matchingCards: [Card]
			if query.count == 1 {
				matchingCards = filtered.filter { card in
					card.name.lowercased().hasPrefix(lowercasedQuery)
				}
			} else {
				matchingCards = filtered.filter { card in
					card.name.localizedCaseInsensitiveContains(query)
				}
			}
			
			results = matchingCards
		}
}



//import SwiftUI
//
//
//class SearchViewModel: ObservableObject {
//	
//	var cardFilters = ["sv"]
//	@Published var searchText = ""
//	@Published var results: [Card] = []
//	@Published var searchTask: Task<Void, Never>? = nil
//	
//	private var debounceTimer: Timer?
//	
//	func filterCards(cards: [Card], searchText: String, cardFilters: [String]) -> [Card] {
//		return cards.filter { card in
//			cardFilters.contains { card.id.contains($0) } &&
//			(searchText.isEmpty || card.name.localizedStandardContains(searchText))
//		}
//	}
//	
//	func performSearch(query: String, allCards: [Card]) async {
//		let lowerCasedQuery = query.lowercased()
//		
//		if lowerCasedQuery.isEmpty {
//			await MainActor.run {
//				results = []
//				return
//			}
//		}
//		let simulatedResults: [Card]
//		
//		let filteredCards = filterCards(cards: allCards, searchText: query, cardFilters: cardFilters)
//		if query.count == 1 {
//			simulatedResults = filteredCards.filter { card in
//				card.name.lowercased().hasPrefix(lowerCasedQuery)
//			}
//		} else {
//			simulatedResults = filteredCards.filter { card in
//				card.name.localizedCaseInsensitiveContains(query)
//			}
//		}
//		
//		await MainActor.run {
//			results = simulatedResults
//		}
//	}
//	
//	func handleSearch(_ query: String, allCards: [Card]) {
//		searchTask?.cancel()
//		searchTask = Task {
//			for await _ in [query].async.debounce(for: .milliseconds(300)) {
//				await performSearch(query: query, allCards: allCards)
//			}
//		}
//	}
//	
//	func debounceSearch(query: String, allCards: [Card]) {
//		debounceTimer?.invalidate()
//		debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) {_ in
//			Task {
//				await self.performSearch(query: query, allCards: allCards)
//			}
//		}
//	}
//}

