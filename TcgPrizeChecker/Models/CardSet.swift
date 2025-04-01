//
//  CardSet.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 29/10/2024.
//

import Foundation

struct CardSet: Decodable, Hashable {

	//let id: String
	//let image: String
	//let localId: String
	let name: CardSetName?
	
	let cards: [Card]
}
