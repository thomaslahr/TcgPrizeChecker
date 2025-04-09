//
//  FilteredCardsView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 13/12/2024.
//

import SwiftUI
import SwiftData
//import AsyncAlgorithms

struct FilteredCardsView: View {
	@Environment(\.modelContext) private var modelContext
	@Environment(\.dismiss) private var dismiss
	@ObservedObject var allCardsViewModel: AllCardsViewModel
	var filteredCards: [Card]
	@State private var isButtonDisabled = false
	@State private var wasCardAddedToDeck = false
	@State private var wasCardAddedAsPlayable = false
	
	@Binding var showImage: Bool
	
	@State private var tappedCard: Card?
	@State private var currentCard: Card?
	
	@State private var cardOffset: CGFloat = 0
	@State private var isDragging = false
	let deckName: String
	//Sendt inn fra MainDeckView
	
	let selectedDeckID: String
	
	let searchText: String
	@Query var decks: [Deck]
	let isInputActive: Binding<Bool>
	
	@State private var isShowingMessage = false
	@State private var messageContent = ""
	
	
	
	var body: some View {
		ZStack {
			VStack {
				if !searchText.isEmpty {
					Text("Number of returned cards: \(filteredCards.count)")
						.font(.caption)
						.fontWeight(.bold)
						.blur(radius: (tappedCard != nil) ? 5 : 0)
						.padding(.top, 8)
					
				}
				//Siden api kallet bruker mye data på fetching av bilder, så kan man velge hvorvidt man vil at det skal vises eller ikke.
				Toggle(isOn: $showImage) {
					Text("Show Image")
				}
				.padding(.top, 8)
				.blur(radius: (tappedCard != nil) ? 5 : 0)
				
				ScrollView {
					LazyVStack {
						ForEach(filteredCards, id: \.id) { card in
							FilteredCardRowView(
								card: card,
								showImage: showImage,
								allCardsViewModel: allCardsViewModel,
								deckName: deckName,
								selectedDeckID: selectedDeckID,
								isButtonDisabled: $isButtonDisabled,
								currentCard: $currentCard,
								wasCardAddedToDeck: $wasCardAddedToDeck,
								wasCardAddedAsPlayable: $wasCardAddedAsPlayable,
								messageContent: $messageContent,
								isShowingMessage: $isShowingMessage,
								tappedCard: $tappedCard,
								isInputActive: isInputActive
							)
								
							Divider()
								.padding(.horizontal)
						}
					}
				}
				.blur(radius: (tappedCard != nil) ? 5 : 0)
				.task {
					print("API call was made for all cards.")
					await allCardsViewModel.fetchAllCards()
				}
				
			}
			.padding(.horizontal, 5)
			
			if isButtonDisabled {
				MessageView(messageContent: "There is no deck,")
					.opacity(wasCardAddedToDeck ? 1 : 0)
			}
			
			if let card = tappedCard {
				TappedCardOverlayView(
					card: card,
					selectedDeckID: selectedDeckID,
					deckName: deckName,
					allCardsViewModel: allCardsViewModel,
					tappedCard: $tappedCard,
					currentCard: $currentCard,
					isButtonDisabled: $isButtonDisabled,
					isShowingMessage: $isShowingMessage,
					wasCardAddedToDeck: $wasCardAddedToDeck,
					wasCardAddedAsPlayable: $wasCardAddedAsPlayable,
					messageContent: $messageContent,
					cardOffset: $cardOffset,
					isDragging: $isDragging,
					searchText: searchText
				)
			}
		}
		.overlay {
			MessageView(messageContent: messageContent)
				.opacity(isShowingMessage ? 1 : 0)
				.zIndex(1)
			
		}
		.onAppear {
			updateButtonState()
		}
	}
	
	private func updateButtonState() {
		if decks.count == 0 {
			isButtonDisabled = true
		} else {
			isButtonDisabled = false
		}
	}
}

#Preview {
	FilteredCardsView(
		allCardsViewModel: AllCardsViewModel(), // Replace with a mock if needed
		filteredCards: [
			Card.sampleCard,
		],
		showImage: .constant(true),
		deckName: "Sample Deck",
		selectedDeckID: "deck-123",
		searchText: "Mock",
		isInputActive: .constant(false)
	)
}
