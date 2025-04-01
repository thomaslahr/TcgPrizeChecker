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
	var category: Category?
	var rarity: String?
	let regulationMark: String?
	
	//Dette er (ment til å være) instansieringen av CardSet-modellen som allerede er her. Den under er en ny versjon.
	//let cardSet: CardSet?
	
	let cardSetCopy: CardSetCopy?
	
	//Properties som gjelder Pokemon
	let hp: Int?
	let types: [EnergyType]?
	let stage: String?
	let evolveFrom: String?
	let retreat: Int?
	let abilities: [Ability]?
	let attacks: [Attack]?
	
	//Properties som kun gjelder Trainer-kort
	let trainerType: TrainerType?
	let trainerCardEffect: String?
	
	enum CodingKeys: String, CodingKey {
		case image
		case category
		case id
		case localId
		case name
		case rarity
		case cardSetCopy = "set"
		case regulationMark
		
		case hp, types, stage, evolveFrom, retreat, abilities, attacks
		case trainerType
		case trainerCardEffect = "effect"
	}
}
