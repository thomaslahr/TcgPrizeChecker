//
//  CardCount.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 30/10/2024.
//

import Foundation

struct CardCount: Decodable, Hashable {
	let official: Int
	let total: Int
}
