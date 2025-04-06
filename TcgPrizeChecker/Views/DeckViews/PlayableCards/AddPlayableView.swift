//
//  AddPlayableView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 12/12/2024.
//

import SwiftUI
import SwiftData

struct AddPlayableView: View {
	@Environment(\.modelContext) private var modelContext
	@Environment(\.dismiss) private var dismiss
	@Query private var playableCards: [PlayableCard]
	
	@State private var isLongPress = false
	@State private var messageContent = ""
	@State private var isShowingMessage = false
	@State private var imageCache: [String: UIImage] = [:]  // 🔹 Image cache

	let columns = [GridItem(.adaptive(minimum: 80))]
	let selectedDeck: Deck?

	var body: some View {
		VStack {
			Text("Tap on a card to add it to a deck, hold to delete it.")
				.font(.callout)
			ScrollView {
				LazyVGrid(columns: columns) {
					ForEach(playableCards, id: \.uniqueId) { card in
							if let cachedImage = imageCache[card.uniqueId] {
								Image(uiImage: cachedImage)
									.resizable()
									.aspectRatio(contentMode: .fit)
									.onTapGesture {
										addCardToDeck(card)
									}
									.onLongPressGesture {
													deleteCard(card)  // 🔹 Long press now only deletes
												}
							} else if let uiImage = UIImage(data: card.imageData) {
								Image(uiImage: uiImage)
									.resizable()
									.aspectRatio(contentMode: .fit)
									.onTapGesture(perform: {
										addCardToDeck(card)
									})
									.onAppear { imageCache[card.uniqueId] = uiImage }
									.onLongPressGesture {
													deleteCard(card)  // 🔹 Long press now only deletes
												}
							}
						
					}
				}
				.padding(.horizontal, 10)
			}
			.scrollIndicators(.hidden)
			.overlay {
				MessageView(messageContent: messageContent)
					.opacity(isShowingMessage ? 1 : 0)
					.animation(.easeInOut(duration: 0.3), value: isShowingMessage)  // 🔹 Faster animation
			}
		}
		.padding(.horizontal, 10)
		.padding(.vertical, 20)
	}

	private func addCardToDeck(_ card: PlayableCard) {
		guard let selectedDeck = selectedDeck else { return }
		
		let newDeckCard = PersistentCard(
			imageData: card.imageData,
			id: card.id,
			localId: card.localId,
			name: card.name,
			uniqueId: UUID().uuidString
		)
		
		selectedDeck.cards.append(newDeckCard)
		modelContext.insert(newDeckCard)
		try? modelContext.save()
		
		messageContent = "\(card.name) was added to the \(selectedDeck.name) deck."
		showMessage()
	}

	private func deleteCard(_ card: PlayableCard) {
		withAnimation {
			messageContent = "\(card.name) was deleted as a playable card."
			modelContext.delete(card)
			try? modelContext.save()
			showMessage()
		}
	}
	private func showMessage() {
		isShowingMessage = true
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
			withAnimation {
				isShowingMessage = false
			}
		}
	}
}


#Preview {
	AddPlayableView(selectedDeck: nil)
}
