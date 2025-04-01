//
//  CardSetName.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 29/10/2024.
//

import SwiftUI

enum CardSetName: String, Decodable, CaseIterable, Hashable {
//	case brilliantStars = "Brilliant Stars"
//	case astralRadiance = "Astral Radiance"
//	case pokemonG0 = "Pokémon GO"
//	case lostOrigin = "Lost Origin"
//	case silverTempest = "Silver Tempest"
//	case crownZenith = "Crown Zenith"
	case svBlackStarPromo = "S&V Promo"
	case scarletAndViolet = "Scarlet & Violet"
	case paldeaEvolved = "Paldea Evolved"
	case obsidianFlames = "Obsidian Flames"
	case pokemon151 = "151"
	case paradoxRift = "Paradox Rift"
	case paldeanFates = "Paldean Fates"
	case temporalForces = "Temporal Forces"
	case twilightMasquerade = "Twilight Masquerade"
	case shroudedFable = "Shrouded Fable"
	case stellarCrown = "Stellar Crown"
	case surgingSparks = "Surging Sparks"
	case prismaticEvolutions = "Prismatic Evolutions"
	case journeyTogether = "Journey Together"
	
	var cardSetNumber: String {
		switch self {
			
//These sets have rotated out, and for simplicity sakes they're not included now.
//		case .brilliantStars:
//			"swsh9"
//		case .astralRadiance:
//			"swsh10"
//		case .pokemonG0:
//			"swsh10.5"
//		case .lostOrigin:
//			"swsh11"
//		case .silverTempest:
//			"swsh12"
//		case .crownZenith:
//			"swsh12.5"
		case .svBlackStarPromo:
			"svp"
		case .scarletAndViolet:
			"sv01"
		case .paldeaEvolved:
			"sv02"
		case .obsidianFlames:
			"sv03"
		case .pokemon151:
			"sv03.5"
		case .paradoxRift:
			"sv04"
		case .paldeanFates:
			"sv04.5"
		case .temporalForces:
			"sv05"
		case .twilightMasquerade:
			"sv06"
		case .shroudedFable:
			"sv06.5"
		case .stellarCrown:
			"sv07"
		case .surgingSparks:
			"sv08"
		case .prismaticEvolutions:
			"sv08.5"
		case .journeyTogether:
			"sv09"
	
		}
	}
	
	var cardSetShortName: String {
		switch self {
//These sets have rotated out, and for simplicity sakes they're not included now.
//		case .brilliantStars:
//			"swsh9"
//		case .astralRadiance:
//			"swsh10"
//		case .pokemonG0:
//			"swsh10.5"
//		case .lostOrigin:
//			"swsh11"
//		case .silverTempest:
//			"swsh12"
//		case .crownZenith:
//			"swsh12.5"
		case .svBlackStarPromo:
			"SVP"
		case .scarletAndViolet:
			"SVI"
		case .paldeaEvolved:
			"PAL"
		case .obsidianFlames:
			"OBF"
		case .pokemon151:
			"MEW"
		case .paradoxRift:
			"PAR"
		case .paldeanFates:
			"PAF"
		case .temporalForces:
			"TEF"
		case .twilightMasquerade:
			"TWM"
		case .shroudedFable:
			"SFA"
		case .stellarCrown:
			"STC"
		case .surgingSparks:
			"SSP"
		case .prismaticEvolutions:
			"PRE"
		case .journeyTogether:
			"JTG"
		}
	}
	
	var cardSetLogo: Image {
		switch self {
			
//These sets have rotated out, and for simplicity sakes they're not included now.
//		case .brilliantStars:
//			Image(.swsh9BrilliantStars)
//		case .astralRadiance:
//			Image(.swsh10AstralRadiance)
//		case .pokemonG0:
//			Image(.swsh105PokemonGo)
//		case .lostOrigin:
//			Image(.swsh11LostOrigin)
//		case .silverTempest:
//			Image(.swsh12SilverTempest)
//		case .crownZenith:
//			Image(.swsh125CrownZenith)
			
		case .svBlackStarPromo:
			Image("")
		case .scarletAndViolet:
			Image(.sv01ScarletAndViolet)
		case .paldeaEvolved:
			Image(.sv02PaldeaEvolved)
		case .obsidianFlames:
			Image(.sv03ObsidianFlames)
		case .pokemon151:
			Image(.sv035151)
		case .paradoxRift:
			Image(.sv04ParadoxRift)
		case .paldeanFates:
			Image(.sv045PaldeanFates)
		case .temporalForces:
			Image(.sv05TemporalForces)
		case .twilightMasquerade:
			Image(.sv06TwilightMasquerade)
		case .shroudedFable:
			Image(.sv065ShroudedFable)
		case .stellarCrown:
			Image(.sv07StellarCrown)
		case .surgingSparks:
			Image(.sv08SurgingSparks)
		case .prismaticEvolutions:
			Image("")
		case .journeyTogether:
			Image("")
		}
	}
}

extension CardSetName {
	/// Get a `CardSetName` from a card ID prefix
	static func fromCardSetID(_ cardSetID: String) -> CardSetName? {
		// Extract the prefix (part before the "-")
		let prefix = cardSetID.split(separator: "-").first.map { String($0) }
		return prefix.flatMap { prefix in
			CardSetName.allCases.first { $0.cardSetNumber == prefix }
		}
	}
}
