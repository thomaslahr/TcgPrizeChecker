//
//  CardSaveInfo.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 19/04/2025.
//

import Foundation

struct CardSaveInfo {
	let imageData: Data
	let card: Card
	let cardToSave: CardSaveType
	let deckName: String
	let selectedDeckID: String
	let selectedDeck: Deck
}
