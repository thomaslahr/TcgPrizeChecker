//
//  DeckSelectionViewModel.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 15/12/2024.
//

import Foundation

class DeckSelectionViewModel: ObservableObject {
	@Published var selectedDeckID: String?
	
	func validateDeckSelection(using decks: [Deck]) {
		if selectedDeckID == nil || !decks.contains(where: { $0.id == selectedDeckID}) {
			selectedDeckID = decks.first?.id
		}
	}

}
