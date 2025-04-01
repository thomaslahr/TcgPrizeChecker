//
//  Answer.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 01/12/2024.
//

import SwiftUI

enum Answer {
	case correct
	case wrong
	case guess
	
	var sfSymbolText: String {
		switch self {
		case .correct:
			"checkmark.circle"
		case .wrong:
			"x.circle"
		case .guess:
			"questionmark.circle"
		}
	}
	
	var sfSymbolColor: Color {
		switch self {
			
		case .correct:
				.green
		case .wrong:
				.red
		case .guess:
				.yellow
		}
	}
}
