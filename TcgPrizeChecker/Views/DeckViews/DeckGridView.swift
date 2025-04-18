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
	@EnvironmentObject private var messageManager: MessageManager
	@ObservedObject var imageCache: ImageCacheViewModel
	@ObservedObject var deckViewModel: DeckViewModel
	@State private var cardOffset: CGFloat = 0
	@State private var isDragging = false
	@State private var cardOpacity: Double = 1.0
	
	
	@Query var deck: [PersistentCard]
	@Query var decks: [Deck]
	
	let selectedDeckID: String
	let columns = [GridItem(.adaptive(minimum: 65))]
	
	
	@State private var currentCardIndex: Int?
	//	@State private var imageCache: [String: UIImage] = [:]
	
	//@Binding var isOverlayActive: Bool
	
	var body: some View {
		ZStack {
			ScrollView {
				ZStack {
					LazyVGrid(columns: columns) {
						if let selectedDeck = decks.first(where: {$0.id == selectedDeckID}) {
							let sortedCards = deckViewModel.sortedCards(for: selectedDeck)
							
							ForEach(sortedCards, id: \.uniqueId) { card in
								let isRevealed = imageCache.revealedCardIDs.contains(card.uniqueId)
								
								Group {
									if let cachedImage = imageCache.cache[card.uniqueId] {
										Image(uiImage: cachedImage)
											.resizable()
											.aspectRatio(contentMode: .fit)
											.frame(maxWidth: 75)
											.opacity(isRevealed ? 1 : 0)
											.onAppear {
												if !isRevealed {
													imageCache.revealCardAtRandom(card)
												}
											}
											.onTapGesture {
												if let index = selectedDeck.cards.firstIndex(where: { $0.uniqueId == card.uniqueId }) {
													currentCardIndex = index
												}
											}
											.onLongPressGesture {
												deleteCard(card)
											}
									} else if let image = UIImage(data: card.imageData) {
										let targetSize = CGSize(width: 140, height: 200)
										if let downscaled = image.downscaled(to: targetSize) {
											Image(uiImage: downscaled)
												.resizable()
												.aspectRatio(contentMode: .fit)
												.frame(maxWidth: 70)
												.opacity(isRevealed ? 1 : 0)
												.onAppear {
													if !isRevealed {
														imageCache.revealCardAtRandom(card)
													}
													imageCache.setImage(downscaled, for: card.uniqueId)
												}
										}
									}
								}
							}
						}
					}
				}
				.padding()
			}
		}
		.onChange(of: selectedDeckID) {
			print("Deck changed")
		}
		.overlay {
			MessageView(messageContent: messageManager.messageContent)
				.opacity(messageManager.isShowingMessage ? 1 : 0)
		}
		.blur(radius: currentCardIndex != nil ? 5 : 0)
		
		if let selectedDeck = decks.first(where: { $0.id == selectedDeckID }),
		   let index = currentCardIndex,
		   selectedDeck.cards.indices.contains(index),
		   let uiImage = UIImage(data: selectedDeck.cards[index].imageData) {
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
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			
		}
	}
	
	private func deleteCard(_ card: PersistentCard) {
		withAnimation {
			if let selectedDeck = decks.first(where: {$0.id == selectedDeckID}) {
				messageManager.messageContent = "\(card.name) was deleted from the \(selectedDeck.name) deck."
			}
			modelContext.delete(card)
			try? modelContext.save()
			messageManager.showMessage()
		}
	}
	//	private func revealCard(_ card: PersistentCard) {
	//		guard !revealedCardIDs.contains(card.uniqueId) else { return }
	//
	//		// Get the index of the card in the selectedDeck's cards array
	//		if let selectedDeck = decks.first(where: { $0.id == selectedDeckID }),
	//		   let index = selectedDeck.cards.firstIndex(where: { $0.uniqueId == card.uniqueId }) {
	//
	//			// Use the index to create a sequential delay
	//			let delay = Double(index) * 0.05 // Delay based on card's index in the array
	//
	//			DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
	//				withAnimation(.easeIn(duration: 0.25)) {
	//					_ = revealedCardIDs.insert(card.uniqueId)
	//				}
	//			}
	//		}
	//	}
}

#Preview {
	DeckGridView(imageCache: ImageCacheViewModel(), deckViewModel: DeckViewModel(imageCache: ImageCacheViewModel()), selectedDeckID: "3318B2A1-9A6E-4B34-884F-E8D52A5811A5")
		.environmentObject(MessageManager())
}
