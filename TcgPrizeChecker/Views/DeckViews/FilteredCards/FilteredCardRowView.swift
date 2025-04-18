//
//  FilteredCardRowView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 05/04/2025.
//

import SwiftData
import SwiftUI


struct FilteredCardRowView: View {
	let card: Card
	let showImage: Bool
	let allCardsViewModel: AllCardsViewModel
	let deckName: String
	let selectedDeckID: String
	@Binding var isButtonDisabled: Bool
	@Binding var currentCard: Card?
	@Binding var wasCardAddedToDeck: Bool
	@Binding var wasCardAddedAsPlayable: Bool
	@Binding var tappedCard: Card?
	let isInputActive: Binding<Bool>
	
	@Query var decks: [Deck]
	
	var deck: [PersistentCard] {
		decks.first(where: { $0.id == selectedDeckID })?.cards ?? []
	}
	
    var body: some View {
		HStack {
			VStack(alignment: .leading) {
				HStack{
						Text(card.name)
					Text("(\(card.localId))")
					}
			//	Text(card.rarity ?? "HALLo")
				
				
				//For å se hvilket set kortet tilhører.
				if let cardSetName = CardSetName.fromCardSetID(card.id) {
					Text("(\(cardSetName.rawValue))")
				}
			}
			
			Spacer()
			
			if showImage {
				CachedImageView(urlString: "\(card.image ?? "")/low.webp")
					.frame(maxWidth: 60)
					.onAppear {
						loadImage(for: card)
					}
					.onTapGesture {
						withAnimation {
							tappedCard = card
							isInputActive.wrappedValue = false
						}
					}
					.padding(.trailing, 10)
			}
			DoubleButtonView(
				allCardsViewModel: allCardsViewModel,
				isButtonDisabled: $isButtonDisabled,
				card: card,
				currentCard: $currentCard,
				selectedDeckID: selectedDeckID,
				deckName: deckName,
				isHorizontal: false,
				cardsInDeck: deck
			)

		}
    }
	private func loadImage(for card: Card) {
		// This method is called only when the card's image is about to appear on screen
		if let imageUrlString = card.image, !imageUrlString.isEmpty {
			// Assuming your CachedImageView handles loading and caching the image
			// You can trigger any additional loading logic here if needed
			print("Loading image for card: \(card.name)")
		}
	}
}

