//
//  DeckInfoView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 28/04/2025.
//

import SwiftUI
import SwiftData

struct DeckInfoView: View {
	
	let selectedDeck: Deck?
	
	let energyTypes = EnergyType.allCases
	


	
	var body: some View {
		
		if let selectedDeck {
			let allPokemonCards = selectedDeck.cards.filter { $0.category == "Pokemon"}
			let allTrainerCards = selectedDeck.cards.filter { $0.category == "Trainer"}
			
			let basicCards = selectedDeck.cards.filter { $0.stage == "Basic"}
			let stage1Cards = selectedDeck.cards.filter { $0.stage == "Stage1"}
			let stage2Cards = selectedDeck.cards.filter { $0.stage == "Stage2"}
			let supporterCards = selectedDeck.cards.filter { $0.trainerType == "Supporter" }
			let itemCards = selectedDeck.cards.filter { $0.trainerType == "Item" }
			let toolCards = selectedDeck.cards.filter { $0.trainerType == "Tool" }
			let stadiumCards = selectedDeck.cards.filter { $0.trainerType == "Stadium" }
			
			
			let allEnergyCards = selectedDeck.cards.filter {$0.category == "Energy"}
			let basicEnergyCards = selectedDeck.cards.filter { card in
				card.category == "Energy" && energyTypes.contains(where: {
					card.name.contains($0.rawValue)
				})
			}
			
			var specialEnergyCards: Int {
				allEnergyCards.count - basicEnergyCards.count
			}
			
			ScrollView {
				Text("Deck Stats")
					.font(.title)
					.fontWeight(.bold)
					.fontDesign(.rounded)
					.padding(.top, 10)
				
				VStack(spacing: 3) {
					Text("Number of Pokémon in the deck: \(allPokemonCards.count)")
						.font(.subheadline)
						.fontWeight(.bold)
						.fontDesign(.rounded)
					
					VStack(alignment: .leading) {
						ViewDescriptionTextView(text:"\(basicCards.count) Basic Pokémon in the deck")
						ViewDescriptionTextView(text:"\(stage1Cards.count) Stage1 Pokémon in the deck")
						ViewDescriptionTextView(text:"\(stage2Cards.count) Stage2 Pokémon in the deck")
					}
					.padding()
					.frame(maxWidth: .infinity, alignment: .leading)
					.background {
						RoundedRectangle(cornerRadius: 12)
							.fill(.thinMaterial)
						
					}
				}
				.padding(.vertical, 5)
					VStack(spacing: 3) {
						Text("Number of Trainers in the deck: \(allTrainerCards.count)")
							.font(.subheadline)
							.fontWeight(.bold)
							.fontDesign(.rounded)
						
						VStack(alignment: .leading) {
							ViewDescriptionTextView(text: "\(supporterCards.count) Supporter Cards")
							ViewDescriptionTextView(text: "\(itemCards.count) Item Cards")
							ViewDescriptionTextView(text: "\(toolCards.count) Tool Cards")
							ViewDescriptionTextView(text: "\(stadiumCards.count) Stadium Cards")
						}
						.padding()
						.frame(maxWidth: .infinity, alignment: .leading)
						.background {
							RoundedRectangle(cornerRadius: 12)
								.fill(.thinMaterial)
							
						}
					}
					.padding(.vertical, 5)
					
					VStack(spacing: 3) {
						Text("Number of Energy in the deck: \(allEnergyCards.count)")
							.font(.subheadline)
							.fontWeight(.bold)
							.fontDesign(.rounded)
						
						VStack(alignment: .leading) {
							ViewDescriptionTextView(text: "\(basicEnergyCards.count) Basic Energy Cards")
							ViewDescriptionTextView(text: "\(specialEnergyCards) Special Energy Cards")
						}
						.padding()
						.frame(maxWidth: .infinity, alignment: .leading)
						.background {
							RoundedRectangle(cornerRadius: 12)
								.fill(.thinMaterial)
							
						}
					}
					.padding(.vertical, 5)
				
				ProbabilityView(
					supporterCards: supporterCards.count,
					basicPokemonCards: basicCards.count
				)
			}
			.padding(.horizontal, 10)
		}
		
	}
	
	
}

#Preview {
	DeckInfoView(selectedDeck: Deck.sampleDeck)
		.background(.red.opacity(0.3))
		.frame(maxHeight: 400)
}
