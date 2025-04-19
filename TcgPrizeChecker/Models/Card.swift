//
//  Card.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 29/10/2024.
//

import Foundation

struct Card: Decodable, Hashable, Identifiable {
	
	//Properties som gjelder alle kort
	let image: String?
	let id: String
	let localId: String
	let name: String
	
	//Disse gjelder ikke på card objectene som er i cardSet
//	var category: Category?
	var rarity: String?
	var category: String?
//	let regulationMark: String?
	
	//Dette er (ment til å være) instansieringen av CardSet-modellen som allerede er her. Den under er en ny versjon.
	//let cardSet: CardSet?
	
	//let cardSetCopy: String?
	
	//Properties som gjelder Pokemon
//	let hp: Int?
//	let types: [EnergyType]?
//	let stage: String?
//	let evolveFrom: String?
//	let retreat: Int?
//	let abilities: [Ability]?
//	let attacks: [Attack]?
//	
//	//Properties som kun gjelder Trainer-kort
//	let trainerType: TrainerType?
//	let trainerCardEffect: String?
	
//	enum CodingKeys: String, CodingKey {
//		case image
//		case category
//		case id
//		case localId
//		case name
//		case rarity
//		case regulationMark
//		
//		case hp, types, stage, evolveFrom, retreat, abilities, attacks
//		case trainerType
//		case trainerCardEffect = "effect"
//	}
}


extension Card {
	static let sampleCard = Card(
		image: "https://assets.tcgdex.net/en/sv/sv01/245",
		id: "sv01-245",
		localId: "245",
		name: "Gardevoir ex"
//		regulationMark: "G",
//		hp: 310,
//		types: [],
//		stage: "Stage 2",
//		evolveFrom: "Kirlia",
//		retreat: 2,
//		abilities: [],
//		attacks: [],
//		trainerType: nil,
//		trainerCardEffect: nil
	)
}
