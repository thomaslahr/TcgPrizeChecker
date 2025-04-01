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
	@Environment(\.dismiss) private var dismiss
	@State private var pressText = "Not pressed"
	@State private var viewSelection = 0

	let columns =  [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]
	
	let selectedDeck: Deck?
	
	@State private var isShowingMessage = false
	@State private var messageContent = ""
	var body: some View {
			VStack {
				Text("Tap on an energy card to add it to your deck:")
				ZStack {
					LazyVGrid(columns: columns) {
						ForEach(EnergyType.allCases.filter { $0 != .dragon }, id: \.rawValue) { energyCard in
							Button {
								if let image = energyCard.energyCardUIImage,
								   let imageData = image.pngData() {
									let newEnergyCard = PersistentCard(
										imageData: imageData,
										id: "",
										localId: "",
										name: energyCard.name,
										uniqueId: UUID().uuidString
									)
									if let selectedDeck = selectedDeck {
										selectedDeck.cards.append(newEnergyCard)
										modelContext.insert(newEnergyCard)
										try? modelContext.save()
										messageContent = "A \(energyCard.name) was added to the \(selectedDeck.name) deck."
										Task {
											await displayMessage()
										}
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
					MessageView(messageContent: messageContent)
						.opacity(isShowingMessage ? 1 : 0)
				}
			}
			.padding(.horizontal, 10)
			.padding(.vertical, 20)
	}
	@MainActor
	func displayMessage() async {
		print("Dislaying message")
		isShowingMessage = true
		try? await Task.sleep(nanoseconds: 1_500_000_000)
		withAnimation {
			isShowingMessage = false
		}
	}
}

#Preview {
	AddEnergyCardView(selectedDeck: nil)
}
