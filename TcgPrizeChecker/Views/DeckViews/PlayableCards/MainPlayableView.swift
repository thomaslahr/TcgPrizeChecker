//
//  MainPlayableView.swift
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
		
		let selectedDeckID = deckSelectionViewModel.selectedDeckID
		VStack {
			HStack(spacing: 3) {
				if deckSelectionViewModel.selectedDeckID != nil {
					Text("Add cards to the")
					CustomPickerMenuView(decks: decks)
					Text("deck.")
				}
			}
			.padding(.top, 15)
			.font(.callout)
				VStack {
					Picker(selection: $viewSelection) {
						Text("Energy Cards").tag(0)
						Text("Playables").tag(1)
					} label: {
						Text("Add energy cards and playables")
					}
					.pickerStyle(.segmented)
					
					switch viewSelection {
					case 0:
						ScrollView {
							AddEnergyCardView(selectedDeck: selectedDeck)
						}
					default:
						var deck: [PersistentCard] {
							decks.first(where: { $0.id == selectedDeckID })?.cards ?? []
						}
						AddPlayableView(selectedDeck: selectedDeck, cardsInDeck: deck)
					}
			}
		}
		VStack {
			Button {
				dismiss()
			} label: {
				Text("Back to Deck")
					.tint(.primary)
			}
			.padding()
			.background {
				RoundedRectangle(cornerRadius: 12)
					.stroke(lineWidth: 2)
			}

		}
	}
}


#Preview {
	PlayableMainView(selectedDeck: nil)
		.environmentObject(DeckSelectionViewModel())
}
