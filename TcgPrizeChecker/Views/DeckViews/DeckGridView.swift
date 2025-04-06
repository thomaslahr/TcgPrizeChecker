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
		.overlay(
			Color.black.opacity(currentCardIndex != nil ? 0.2 : 0)
		)
		.overlay {
			MessageView(messageContent: messageContent)
				.opacity(isShowingMessage ? 1 : 0)
		}
		.blur(radius: currentCardIndex != nil ? 5 : 0)
		
		if let selectedDeck = decks.first(where: { $0.id == selectedDeckID }),
		   let index = currentCardIndex,
		   selectedDeck.cards.indices.contains(index),
		   let uiImage = imageCache[selectedDeck.cards[index].uniqueId] {
			GeometryReader { geometry in
				ZStack {
					HStack {
						Button {
							if let selectedDeck = decks.first(where: { $0.id == selectedDeckID }),
							   let index = currentCardIndex {
								let nextIndex = (index - 1) % selectedDeck.cards.count
								currentCardIndex = nextIndex
							}
						} label: {
							ZStack {
								Image(systemName: "arrow.left")
									.foregroundStyle(.white)
									.fontWeight(.bold)
								RoundedRectangle(cornerRadius: 12)
									.frame(maxHeight: 100)
									.tint(.clear)
							}
						}
						.disabled(currentCardIndex == 0)
						VStack {
							Text(selectedDeck.cards[currentCardIndex ?? 0].name)
								.frame(width: 250)
								.font(.title2)
								.fontWeight(.bold)
								.fontDesign(.rounded)
								.multilineTextAlignment(.center)
							
							Image(uiImage: uiImage)
								.resizable()
								.frame(width: 300, height: 400)
								.transition(.scale)
								.offset(y: cardOffset)
								.opacity(cardOpacity)
								.onTapGesture {
									withAnimation(.linear(duration: 0.2)) {
										cardOpacity = 0  // Fade out first
									}
									DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
										currentCardIndex = nil // Remove after animation completes
										cardOpacity = 1  // Reset for next time
									}
								}
								.gesture(
									DragGesture()
										.onChanged { value in
											isDragging = true
											cardOffset = value.translation.height
										}
										.onEnded { value in
											if abs(value.translation.height) > 150 { // If swiped far enough
												withAnimation(.spring(response: 0.2, dampingFraction: 0.6, blendDuration: 0.1)) {
													cardOffset = 0
													currentCardIndex = nil
													
												}
											} else { // Snap back if not far enough
												withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.1)) {
													cardOffset = 0
												}
												isDragging = false
											}
										}
								)
						}
						Button {
							if let selectedDeck = decks.first(where: { $0.id == selectedDeckID }),
							   let index = currentCardIndex {
								let nextIndex = (index + 1) % selectedDeck.cards.count
								currentCardIndex = nextIndex
							}
						} label: {
							Image(systemName: "arrow.right")
								.foregroundStyle(.white)
								.fontWeight(.bold)
							RoundedRectangle(cornerRadius: 12)
								.frame(maxHeight: 100)
								.tint(.clear)
						}
						.disabled(currentCardIndex == selectedDeck.cards.count - 1)
					}
					.position(x: geometry.size.width / 2, y: geometry.size.height / 2.5)
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			}
			.background(.black.opacity(0.7)).ignoresSafeArea().opacity(cardOpacity)
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
