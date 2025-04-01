//
//  PlayableMainView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 12/12/2024.
//

import SwiftUI
import SwiftData

struct PlayableMainView: View {
	private let dataService = DataService()
	
	@Environment(\.modelContext) private var modelContext
	@Environment(\.dismiss) private var dismiss
	
	@EnvironmentObject var deckSelectionViewModel: DeckSelectionViewModel
	
	@State private var pressText = "Not pressed"
	@State private var viewSelection = 0
	let selectedDeck: Deck?
	@Query var decks: [Deck]
	
	let columns =  [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]
	
	var body: some View {
		VStack {
			HStack(spacing: 0) {
				if deckSelectionViewModel.selectedDeckID != nil {
					Text("Add cards to the")
					Picker("Choose Deck", selection: $deckSelectionViewModel.selectedDeckID) {
						ForEach(decks) { deck in
							Text(deck.name).tag(deck.id  as String?)
						}
					}
					.pickerStyle(.automatic)
					Text("deck.")
				}
			}
			.padding(.top, 20)
			ScrollView {
				Picker(selection: $viewSelection) {
					Text("Energy Cards").tag(0)
					Text("Playables").tag(1)
				} label: {
					Text("Add energy cards and playables")
				}
				.pickerStyle(.segmented)
				
				switch viewSelection {
				case 0:
					AddEnergyCardView(selectedDeck: selectedDeck)
				default:
					AddPlayableView(selectedDeck: selectedDeck)
				}
			}
			Button {
				dismiss()
			} label: {
				Text("Back to Deck")
					.tint(.primary)
			}
			.padding()

		}
	}
}


#Preview {
	PlayableMainView(selectedDeck: nil)
		.environmentObject(DeckSelectionViewModel())
}
