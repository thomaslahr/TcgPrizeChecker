//
//  DeckState.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 08/04/2025.
//

import Foundation

struct DeckState {
	var cardsInHand: [PersistentCard] = []
	var prizeCards: [PersistentCard] = []
	var remainingCardsInDeck: [PersistentCard] = []
	
	static let sampleDeck = PersistentCard.sampleDeck
}
