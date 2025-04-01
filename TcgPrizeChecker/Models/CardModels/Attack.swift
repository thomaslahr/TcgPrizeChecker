//
//  Attack.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 30/10/2024.
//

import Foundation

struct Attack: Decodable, Hashable {
	//energyCost var egentlig skrevet som "[Energy.RawValue]". Det er bedre sånn koden er nå, men jeg skjønner ikke heelt hvorfor det funker..
	//Svar: Mye foregår i kulissene pga Decodable. Det som er avgjørende er at rawValue-en til Energy samsvarer med string-en som vi får fra json-apiet
	//EnergyCost må bli gjort om til optional siden noen angrep ikke koster noe, feks Cleffa fra Obsidian Flames.
	let energyCost: [EnergyType]
	let name: String
	//Må være optional siden ikke alle angrep har en effekt.
	let effect: String?
	let damage: DamageValue?
	
	enum CodingKeys: String, CodingKey {
		case energyCost = "cost"
		case name
		case effect
		case damage
	}
}
