//
//  CustomPickerMenuView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 07/04/2025.
//

import SwiftUI

struct CustomPickerMenuView: View {
	@EnvironmentObject var deckSelectionViewModel: DeckSelectionViewModel
	let decks: [Deck]
    var body: some View {
		HStack(spacing: 0) {
			Menu {
				Picker("Choose deck", selection: $deckSelectionViewModel.selectedDeckID.bound(to: decks)) {
					ForEach(decks) { deck in
						Text(deck.name).tag(deck.id as String?)
					}
				}
			} label: {
				HStack(spacing: 5) {
					Text(
						deckSelectionViewModel.selectedDeckID.flatMap { id in
							decks.first(where: {$0.id == id})?.name
						} ?? "Choose a deck"
					)
				
					.fontWeight(.bold)
					.fontDesign(.rounded)
				//	Image(systemName: "arrow.up.and.down")
				}
			}
		}
    }
}

#Preview {
	CustomPickerMenuView(
		decks: [Deck.sampleDeck]
	)
}
