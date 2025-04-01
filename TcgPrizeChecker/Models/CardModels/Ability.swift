//
//  Ability.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 01/11/2024.
//

import Foundation

struct Ability: Decodable, Hashable {
	let name: String
	let type: String
	let effect: String
}
