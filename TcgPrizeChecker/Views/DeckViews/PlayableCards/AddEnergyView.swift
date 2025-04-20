//
//  AddEnergyCardView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 07/11/2024.
//

import SwiftUI
import SwiftData

struct AddEnergyCardView: View {
	private let dataService = DataService()
	
	@Environment(\.modelContext) private var modelContext
	@EnvironmentObject private var messageManager: MessageManager
	@Environment(\.dismiss) private var dismiss
	@State private var pressText = "Not pressed"
	@State private var viewSelection = 0

	let columns =  [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]
	
	let selectedDeck: Deck?
	
	var body: some View {
			VStack {
				VStack {
					ViewDescriptionTextView(text: "Tap on an enery card \n to add a copy to the deck")
						.multilineTextAlignment(.center)
				}
				.fontWeight(.semibold)
				.fontDesign(.rounded)
				.padding(.bottom, 10)
				ZStack {
					LazyVGrid(columns: columns) {
						ForEach(EnergyType.allCases.filter { $0.energyCardUIImage != nil }, id: \.rawValue) { energyCard in
							Button {
								if let image = energyCard.energyCardUIImage,
								   let imageData = image.pngData() {
									let newEnergyCard = PersistentCard(
										imageData: imageData,
										id: "",
										localId: "",
										name: energyCard.name,
										uniqueId: UUID().uuidString,
										category: "Energy",
										trainerType: nil,
										stage: nil,
										evolveFrom: nil
									)
									if let selectedDeck = selectedDeck {
										selectedDeck.cards.append(newEnergyCard)
										modelContext.insert(newEnergyCard)
										try? modelContext.save()
										messageManager.messageContent = "A \(energyCard.name) was added to the \(selectedDeck.name) deck."
									
										messageManager.showMessage()
									}
								}
								print(energyCard.rawValue)
							} label: {
								if let uiImage = energyCard.energyCardUIImage {
									Image(uiImage: uiImage)
										.resizable()
										.aspectRatio(contentMode: .fit)
										.frame(maxWidth: 110)
								}
							}
							.padding(5)
						}
					}
					.overlay {
						MessageView(messageContent: messageManager.messageContent)
							.opacity(messageManager.isShowingMessage ? 1 : 0)
					}
					
				}
				
				
			}
			.padding(10)
	}
}

#Preview {
	AddEnergyCardView(selectedDeck: nil)
		.environmentObject(MessageManager())
}
