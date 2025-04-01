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
	
	
	init(name: String, cards: [PersistentCard] = []) {
		self.name = name
		self.cards = cards
	}
}
