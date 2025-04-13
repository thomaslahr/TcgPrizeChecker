//
//  SearchViewModel.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 09/04/2025.
//

import SwiftUI


class SearchViewModel: ObservableObject {
	
	var cardFilters = ["sv"]
	@Published var searchText = ""
	@Published var results: [Card] = []
	@Published var searchTask: Task<Void, Never>? = nil
	
	private var debounceTimer: Timer?
	
	func filterCards(cards: [Card], searchText: String, cardFilters: [String]) -> [Card] {
		return cards.filter { card in
			cardFilters.contains { card.id.contains($0) } &&
			(searchText.isEmpty || card.name.localizedStandardContains(searchText))
		}
	}
	
	func performSearch(query: String, allCards: [Card]) async {
		let lowerCasedQuery = query.lowercased()
		
		if lowerCasedQuery.isEmpty {
			await MainActor.run {
				results = []
				return
			}
		}
		let simulatedResults: [Card]
		
		let filteredCards = filterCards(cards: allCards, searchText: query, cardFilters: cardFilters)
		if query.count == 1 {
			simulatedResults = filteredCards.filter { card in
				card.name.lowercased().hasPrefix(lowerCasedQuery)
			}
		} else {
			simulatedResults = filteredCards.filter { card in
				card.name.localizedCaseInsensitiveContains(query)
			}
		}
		
		await MainActor.run {
			results = simulatedResults
		}
	}
	
	func handleSearch(_ query: String, allCards: [Card]) {
		searchTask?.cancel()
		searchTask = Task {
			for await _ in [query].async.debounce(for: .milliseconds(300)) {
				await performSearch(query: query, allCards: allCards)
			}
		}
	}
	
	func debounceSearch(query: String, allCards: [Card]) {
		debounceTimer?.invalidate()
		debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) {_ in
			Task {
				await self.performSearch(query: query, allCards: allCards)
			}
		}
	}
}

