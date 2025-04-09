//
//  DeckAndHandView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 08/04/2025.
//

import SwiftUI

struct DeckAndHandView: View {
	@Binding var deckSpacing: CGFloat
	@Binding var handSpacing: CGFloat
	@Binding var tappedDeck: Bool
	@Binding var tappedHand: Bool
	@Binding var isViewTapped: Bool
	
	let deck: DeckState
	let isRightCardOnTop: Bool
	
	
    var body: some View {
		LazyVStack {
			DeckPartView(
				whichCards: "Cards In Deck",
				cards: deck.remainingCardsInDeck,
				isRightCardOnTop: isRightCardOnTop,
				isCardsInHand: false,
				spacing: $deckSpacing,
				tappedDeck: $tappedDeck,
				isViewTapped: isViewTapped
				
			)
			.opacity(tappedHand ? 0 : 1)
			.scaleEffect(tappedDeck ? 2.0 : 1.0)
			.zIndex(tappedDeck ? 1 : 0) // Bring to front when tapped
			.onTapGesture {
				withAnimation(.easeInOut(duration: 0.2)) {
					tappedDeck.toggle()
					isViewTapped.toggle()
				}
			}
			.padding(.top, tappedDeck ? 150 : 0)
			
			
			DeckPartView(
				whichCards: "Cards In Hand",
				cards: deck.cardsInHand,
				isRightCardOnTop: isRightCardOnTop,
				isCardsInHand: true,
				spacing: $handSpacing,
				tappedDeck: $tappedHand,
				isViewTapped: isViewTapped
			)
			.opacity(tappedDeck ? 0 : 1)
			.scaleEffect(tappedHand ? 2.0 : 1.0)
			.zIndex(tappedHand ? 1 : 0) // Bring to front when tapped
			.onTapGesture {
				withAnimation(.easeInOut(duration: 0.2)) {
					tappedHand.toggle()
					isViewTapped.toggle()
				}
			}
			.padding(.bottom, tappedHand ? 350 : 0)
			
			
			
		}
    }
}

#Preview {
	DeckAndHandView(
		deckSpacing: .constant(-72),
		handSpacing: .constant(-72),
		tappedDeck: .constant(false),
		tappedHand: .constant(false),
		isViewTapped: .constant(false),
		deck: DeckState(
			cardsInHand: PersistentCard.sampleDeck,
			remainingCardsInDeck: PersistentCard.sampleDeck
		),
		isRightCardOnTop: false
	)
}
