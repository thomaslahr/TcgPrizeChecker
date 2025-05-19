//
//  MatchedCard.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 09/05/2025.
//

import Foundation

struct MatchedCard: Identifiable {
	var quantity: Int
	let card: Card
	
	var id: String { card.id }
}

extension MatchedCard {
	static let sample = MatchedCard(
		quantity: 2,
		card: .sampleCard
	)
}
