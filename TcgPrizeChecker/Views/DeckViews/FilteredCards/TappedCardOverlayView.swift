//
//  TappedCardOverlayView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 06/04/2025.
//

import SwiftData
import SwiftUI

struct TappedCardOverlayView: View {
	
	@Environment(\.colorScheme) private var colorScheme
	let card: Card
	let selectedDeckID: String
	let deckName: String
	let allCardsViewModel: AllCardsViewModel
	@Binding var tappedCard: Card?
	@Binding var currentCard: Card?
	@Binding var isButtonDisabled: Bool
	@Binding var isShowingMessage: Bool
	@Binding var wasCardAddedToDeck: Bool
	@Binding var wasCardAddedAsPlayable: Bool
	@Binding var messageContent: String
	@Binding var cardOffset: CGFloat
	@Binding var isDragging: Bool
	let searchText: String
	
	@Query var decks: [Deck]
	
	var deck: [PersistentCard] {
		decks.first(where: { $0.id == selectedDeckID })?.cards ?? []
	}
	var body: some View {
		GeometryReader { geometry in
			VStack {
				Text(card.name)
					.frame(width: 250)
					.font(.title2)
					.fontWeight(.bold)
					.fontDesign(.rounded)
					.multilineTextAlignment(.center)
				
				CachedImageView(urlString: "\(card.image ?? "")/high.webp")
					.frame(width: 300, height: 400)
					.transition(.scale)
					.offset(y: cardOffset)
					.onTapGesture {
						//Kan fikses til noe penere, om man finner en måte å sette tapped card til nil.
						withAnimation(.linear(duration: 0.2)) {
							tappedCard = nil
							//	isInputActive.wrappedValue = true
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
										tappedCard = nil
										
									}
								} else { // Snap back if not far enough
									withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.1)) {
										cardOffset = 0
									}
									isDragging = false
								}
							}
					)
				DoubleButtonView(
					allCardsViewModel: allCardsViewModel,
					isButtonDisabled: $isButtonDisabled,
					card: card,
					currentCard: $currentCard,
					selectedDeckID: selectedDeckID,
					deckName: deckName,
					isHorizontal: true,
					cardsInDeck: deck)
				.scaleEffect(1.5)
				.padding(.top, 10)
			}
			.position(x: geometry.size.width / 2, y: geometry.size.height / 2.2)
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.background(colorScheme == .dark ? .black.opacity(0.7) : .white.opacity(0.7)).ignoresSafeArea()
			.onChange(of: searchText) {
				tappedCard = nil
			}
		}
	}
}

//#Preview {
//	TappedCardOverlayView()
//}
