//
//  TrainerCardType.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 01/11/2024.
//

import SwiftUI

enum TrainerType: String, Decodable {
	case supporter = "Supporter"
	case item = "Item"
	case tool = "Tool"
	case stadium = "Stadium"
	
	var trainerColor: Color {
		switch self {
			
		case .supporter:
				.supporterRed
		case .item:
				.itemBlue
		case .tool:
				.toolPurple
		case .stadium:
				.stadiumGreen
		}
	}
}
