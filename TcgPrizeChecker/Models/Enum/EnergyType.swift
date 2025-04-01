//
//  Energy.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 01/11/2024.
//

import SwiftUI

enum EnergyType: String, Decodable, Hashable, Identifiable, CaseIterable {
	
	case colorless = "Colorless"
	case darkness = "Darkness"
	case dragon = "Dragon"
	//case fairy = "Fairy"
	case fighting = "Fighting"
	case fire = "Fire"
	case grass = "Grass"
	case lightning = "Lightning"
	case metal = "Metal"
	case psychic = "Psychic"
	case water = "Water"
	
	
	var id: Self { self }
	
	var symbol: Image {
		switch self {
			
		case .colorless:
			Image(.colorless)
		case .darkness:
			Image(.darkness)
		case .fighting:
			Image(.fighting)
		case .fire:
			Image(.fire)
		case .grass:
			Image(.grass)
		case .lightning:
			Image(.lightning)
		case .metal:
			Image(.metal)
		case .psychic:
			Image(.psychic)
		case .water:
			Image(.water)
		case .dragon:
			Image(.dragon)
		}
	}
	
	var name: String {
		switch self {
			
		case .colorless:
			"Double Turbo Energy"
		case .darkness:
			"Darkness Energy"
		case .fighting:
			"Fighting Energy"
		case .fire:
			"Fire Energy"
		case .grass:
			"Grass Energy"
		case .lightning:
			"Lightning Energy"
		case .metal:
			"Metal Energy"
		case .psychic:
			"Psychic Energy"
		case .water:
			"Water Energy"
		case .dragon:
			"Dragon Energy"
		}
	}
	
//	var energyCard: Image? {
//		
//		switch self {
//		case .colorless:
//			Image(.doubleTurboEnergy)
//		case .darkness:
//			Image(.darknessEnergy)
//		case .fighting:
//			Image(.fightingEnergy)
//		case .fire:
//			Image(.fireEnergy)
//		case .grass:
//			Image(.grassEnergy)
//		case .lightning:
//			Image(.lightningEnergy)
//		case .metal:
//			Image(.metalEnergy)
//		case .psychic:
//			Image(.psychicEnergy)
//		case .water:
//			Image(.waterEnergy)
//		case .dragon:
//			nil
//		}
//	}
	
	var energyCardUIImage: UIImage? {
			switch self {
			case .colorless: return UIImage(named: "doubleTurboEnergy")
			case .darkness: return UIImage(named: "darknessEnergy")
			case .fighting: return UIImage(named: "fightingEnergy")
			case .fire: return UIImage(named: "fireEnergy")
			case .grass: return UIImage(named: "grassEnergy")
			case .lightning: return UIImage(named: "lightningEnergy")
			case .metal: return UIImage(named: "metalEnergy")
			case .psychic: return UIImage(named: "psychicEnergy")
			case .water: return UIImage(named: "waterEnergy")
			case .dragon: return nil
			}
		}
}

