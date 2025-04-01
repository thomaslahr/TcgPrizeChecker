//
//  PersistentCard.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 21/11/2024.
//

import Foundation
import SwiftData
import UIKit

@Model
class PersistentCard {
	
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

extension PersistentCard {
	static let sampleDeck: [PersistentCard] = [
		PersistentCard(imageData: UIImage(named: "psychicEnergy")?.pngData() ?? Data(), id: "", localId: "", name: "Card", uniqueId: UUID().uuidString),
		PersistentCard(imageData: UIImage(named: "psychicEnergy")?.pngData() ?? Data(), id: "", localId: "", name: "Card", uniqueId: UUID().uuidString),
		PersistentCard(imageData: UIImage(named: "psychicEnergy")?.pngData() ?? Data(), id: "", localId: "", name: "Card", uniqueId: UUID().uuidString),
		PersistentCard(imageData: UIImage(named: "psychicEnergy")?.pngData() ?? Data(), id: "", localId: "", name: "Card", uniqueId: UUID().uuidString),
		PersistentCard(imageData: UIImage(named: "psychicEnergy")?.pngData() ?? Data(), id: "", localId: "", name: "Card", uniqueId: UUID().uuidString),
		PersistentCard(imageData: UIImage(named: "psychicEnergy")?.pngData() ?? Data(), id: "", localId: "", name: "Card", uniqueId: UUID().uuidString),
		PersistentCard(imageData: UIImage(named: "psychicEnergy")?.pngData() ?? Data(), id: "", localId: "", name: "Card", uniqueId: UUID().uuidString),
		PersistentCard(imageData: UIImage(named: "psychicEnergy")?.pngData() ?? Data(), id: "", localId: "", name: "Card", uniqueId: UUID().uuidString),
		PersistentCard(imageData: UIImage(named: "psychicEnergy")?.pngData() ?? Data(), id: "", localId: "", name: "Card", uniqueId: UUID().uuidString),
		PersistentCard(imageData: UIImage(named: "psychicEnergy")?.pngData() ?? Data(), id: "", localId: "", name: "Card", uniqueId: UUID().uuidString),
	]
}
