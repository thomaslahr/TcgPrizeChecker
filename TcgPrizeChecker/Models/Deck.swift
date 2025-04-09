//
//  Deck.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 14/12/2024.
//

import Foundation
import SwiftData

@Model
class Deck {
	var name: String
	var id = UUID().uuidString
	@Relationship(deleteRule: .cascade) var cards: [PersistentCard] = []
	@Relationship(deleteRule: .cascade) var results: [PrizeCheckResult] = []
	
	
	init(name: String, cards: [PersistentCard] = [], results: [PrizeCheckResult] = []) {
		self.name = name
		self.cards = cards
		self.results = results
	}
}

extension Deck {
	static let sampleDeck = Deck(name: "Gardevoir ex")
}
