//
//  CardSetCopy.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 02/11/2024.
//

import Foundation

struct CardSetCopy: Decodable, Hashable {
	let cardCount: CardCount
	let id: String
	let logo: String?
	let name: CardSetName
	let symbol: String?
	
	
}
