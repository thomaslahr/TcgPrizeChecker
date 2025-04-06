//
//  FilteredCardRowView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 05/04/2025.
//

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
	@Binding var messageContent: String
	@Binding var isShowingMessage: Bool
	@Binding var tappedCard: Card?
	let isInputActive: Binding<Bool>
	
    var body: some View {
		HStack {
			VStack(alignment: .leading) {
					Text(card.name)
				
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
				isShowingMessage: $isShowingMessage,
				wasCardAddedToDeck: $wasCardAddedToDeck,
				wasCardAddedAsPlayable: $wasCardAddedAsPlayable,
				deckName: deckName,
				messageContent: $messageContent,
				isHorizontal: false
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

//#Preview {
//	FilteredCardRowView(card: <#Card#>, showImage: <#Bool#>, allCardsViewModel: <#AllCardsViewModel#>, deckName: <#String#>, selectedDeckID: <#String#>, isButtonDisabled: <#Binding<Bool>#>, currentCard: <#Binding<Card?>#>, isMessageShowing: <#Binding<Bool>#>, wasCardAddedToDeck: <#Binding<Bool>#>, wasCardAddedAsPlayable: <#Binding<Bool>#>, messageContent: <#Binding<String>#>, tappedCard: <#Binding<Card>#>, isInputActive: <#Binding<Bool>#>)
//}
