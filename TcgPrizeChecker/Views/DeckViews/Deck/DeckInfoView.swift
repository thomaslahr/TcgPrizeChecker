//
//  DeckInfoView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 07/04/2025.
//

import SwiftUI
import SwiftData
struct DeckInfoView: View {
	@Binding var viewSelection: Int
	@Query private var decks: [Deck]
	//@Binding var selectedDeck: Deck?
	var selectedDeckID: String?
	@Binding var activeModal: DeckModal?
	@ObservedObject var deckViewModel: DeckViewModel
	
	private var selectedDeck: Deck? {
		decks.first(where: {$0.id == selectedDeckID})
	}
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
			if let selectedDeck {
				WarningTextView(text: "There are \(selectedDeck.cards.count) cards in the deck.", changeColor: selectedDeck.cards.count > 60)
			}
			Spacer()
			HStack(spacing: 5){
				SortMenuView(deckViewModel: deckViewModel, paddingSize: 11.5, fontSize: 17)
				
				Button {
					activeModal = .playable
				} label: {
						Image(systemName: "tray.2")
						.foregroundStyle(.white)
						.padding(10)
							.background {
								RoundedRectangle(cornerRadius: 8)
									.fill(GradientColors.primaryAppColor)
							}
				}
				.accessibilityLabel("Show playable cards")
				.disabled(decks.isEmpty)
			}
	
		}
		.padding(.top, 10)
		.padding([.bottom, .horizontal], 10)
	
    }
}

#Preview {
	DeckInfoView(
		viewSelection: 
				.constant(0),
		activeModal: 
				.constant(.none),
		deckViewModel: DeckViewModel(
			imageCache: ImageCacheViewModel()
		)
	)
}
