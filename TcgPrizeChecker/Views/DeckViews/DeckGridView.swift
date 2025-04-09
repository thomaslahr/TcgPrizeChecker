//
//  DeckGridView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 28/11/2024.
//

import SwiftUI
import SwiftData

struct DeckGridView: View {
	@Environment(\.modelContext) private var modelContext
	@State private var isShowingMessage = false
	@State private var messageContent = ""
	@State private var cardOffset: CGFloat = 0
	@State private var isDragging = false
	@State private var cardOpacity: Double = 1.0

	@Query var deck: [PersistentCard]
	@Query var decks: [Deck]

	let selectedDeckID: String
	let columns = [GridItem(.adaptive(minimum: 65))]
	
	
	@State private var currentCardIndex: Int?
	@State private var imageCache: [String: UIImage] = [:]
	
	var body: some View {
		ZStack {
			ScrollView {
				Text("Tap on a card to enlarge, hold to delete it.")
					.font(.callout)
				ZStack {
					LazyVGrid(columns: columns) {
						if let selectedDeck = decks.first(where: {$0.id == selectedDeckID}) {
							ForEach(selectedDeck.cards, id: \.uniqueId) { card in
								if let cachedImage = imageCache[card.uniqueId] {
									Image(uiImage: cachedImage)
										.resizable()
										.aspectRatio(contentMode: .fit)
										.frame(maxWidth: 75)
										.onTapGesture {
											if let selectedDeck = decks.first(where: { $0.id  == selectedDeckID }),
											   let index = selectedDeck.cards.firstIndex(where: {$0.uniqueId == card.uniqueId}) {
												currentCardIndex = index
											}
										}
										.onLongPressGesture {
											deleteCard(card)
										}
								} else if let image = UIImage(data: card.imageData) {
									Image(uiImage: image)
										.resizable()
										.aspectRatio(contentMode: .fit)
										.frame(maxWidth: 75)
										.onAppear {
											imageCache[card.uniqueId] = image // Store it in cache
										}
								}
							}
						}
					}
				}
				.padding()
			}
		}
		.overlay {
			MessageView(messageContent: messageContent)
				.opacity(isShowingMessage ? 1 : 0)
		}
		.blur(radius: currentCardIndex != nil ? 5 : 0)
		
		if let selectedDeck = decks.first(where: { $0.id == selectedDeckID }),
		   let index = currentCardIndex,
		   selectedDeck.cards.indices.contains(index),
		   let uiImage = imageCache[selectedDeck.cards[index].uniqueId] {
			DeckCardOverlayView(
				decks: decks,
				selectedDeckID: selectedDeckID,
				currentCardIndex: $currentCardIndex,
				selectedDeck: selectedDeck,
				uiImage: uiImage,
				cardOffset: $cardOffset,
				cardOpacity: $cardOpacity,
				isDragging: $isDragging
			)
		}
	}
	
	private func deleteCard(_ card: PersistentCard) {
		withAnimation {
			if let selectedDeck = decks.first(where: {$0.id == selectedDeckID}) {
				messageContent = "\(card.name) was deleted from the \(selectedDeck.name) deck."
			}
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
	DeckGridView(selectedDeckID: "3318B2A1-9A6E-4B34-884F-E8D52A5811A5")
}
