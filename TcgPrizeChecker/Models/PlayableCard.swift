//
//  PlayableCard.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 12/12/2024.
//

import Foundation

import Foundation
import SwiftData

@Model
class PlayableCard {
	
	//Properties som gjelder alle kort
	var imageData: Data
	var id: String
	var localId: String
	var name: String
	var uniqueId: String
	
	init(
		imageData: Data,
		id: String,
		localId: String,
		name: String,
		uniqueId: String
	) {
		self.imageData = imageData
		self.id = id
		self.localId = localId
		self.name = name
		self.uniqueId = uniqueId
	}
	
	enum CodingKeys: String, CodingKey {
		case imageData = "image"
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

