//
//  ParsedCardLine.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 07/05/2025.
//

import Foundation

struct ParsedCardLine: Hashable {
	let quantity: Int
	let name: String
	let localId: String  // Already zero-padded during parsing

	// Parse deck list
	static func parseDeckList(_ text: String) -> [ParsedCardLine] {
		var parsedCards: [ParsedCardLine] = []

		for line in text.split(separator: "\n") {
			let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
			guard !trimmedLine.isEmpty else { continue }

			let components = trimmedLine.split(separator: " ")
			guard components.count >= 4 else { continue }

			guard let quantity = Int(components[0]) else { continue }

			let rawLocalId = components.last!
			let paddedLocalId = String(format: "%03d", Int(rawLocalId) ?? 0)

			let nameComponents = components[1..<(components.count - 2)]
			let name = nameComponents.joined(separator: " ")

			parsedCards.append(.init(quantity: quantity, name: name, localId: paddedLocalId))
		}

		return parsedCards
	}
}

extension ParsedCardLine {
	static let sample = ParsedCardLine(
		quantity: 2,
		name: "Gardevoir",
		localId: "246"
	)
}

