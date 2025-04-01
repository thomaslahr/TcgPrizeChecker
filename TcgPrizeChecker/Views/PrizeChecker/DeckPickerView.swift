//
//  DeckPickerView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 18/12/2024.
//

import SwiftUI

struct DeckPickerView: View {
	
	@EnvironmentObject var deckSelectionViewModel: DeckSelectionViewModel
	let decks: [Deck]
    var body: some View {
		Picker("Choose Deck", selection: $deckSelectionViewModel.selectedDeckID) {
			ForEach(decks) { deck in
				Text(deck.name).tag(deck.id as String?)
			}
		}
    }
}

#Preview {
	DeckPickerView(decks: [
		Deck(name: "Gardevoir ex", results: []),
		Deck(name: "Charizard ex", results: []),
		Deck(name: "Lost Box", results: [])
	])
		.environmentObject(DeckSelectionViewModel())
}
