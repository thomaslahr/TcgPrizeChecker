//
//  DamageValue.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 01/11/2024.
//

import Foundation

enum DamageValue: Decodable, Hashable {
	case int(Int)
	case string(String)
	
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		
		if let intValue = try? container.decode(Int.self) {
			self = .int(intValue)
		} else if let stringValue = try? container.decode(String.self) {
			self = .string(stringValue)
		} else {
			throw DecodingError.typeMismatch(DamageValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected string or int value."))
		}
	}
	
	var asString: String {
		switch self {
			
		case .int(let intValue):
			return "\(intValue)"
		case .string(let stringValue):
			return stringValue
		}
	}

}
