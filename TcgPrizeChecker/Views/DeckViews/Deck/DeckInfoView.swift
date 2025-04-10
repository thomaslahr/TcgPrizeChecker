//
//  DeckInfoView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 07/04/2025.
//

import SwiftUI

struct DeckInfoView: View {
	@Binding var viewSelection: Int
	var decks: [Deck]
	var selectedDeck: Deck?
	@Binding var activeModal: DeckModal?
	
    var body: some View {
		Picker(selection: $viewSelection) {
			Text("List View").tag(0)
			Text("Grid View").tag(1)
		} label: {
			Text("Change View Type")
		}
		.pickerStyle(.segmented)
		
		HStack {
			
			// En enkel count for å holde styr på antall kort i decket.
			if let selectedDeck = selectedDeck {
				WarningTextView(text: "There are \(selectedDeck.cards.count) cards in the deck.", changeColor: selectedDeck.cards.count > 60)
			}
			Spacer()
			Button {
				activeModal = .playable
			} label: {
					Label("Playables", systemImage: "tray.2")
			}
			.buttonStyle(.borderedProminent)
			.padding(.horizontal)
			.disabled(decks.isEmpty)
		}
		.padding([.top, .horizontal], 10)
    }
}

#Preview {
	DeckInfoView(
		viewSelection: .constant(0),
		decks: [Deck.sampleDeck], activeModal: .constant(.none)
	)
}
