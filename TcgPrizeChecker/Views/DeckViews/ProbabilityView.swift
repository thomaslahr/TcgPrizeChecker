//
//  ProbabilityView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 29/04/2025.
//

import SwiftUI

struct ProbabilityView: View {
	
	let supporterCards: Int
	let basicPokemonCards: Int
	
	
    var body: some View {
		let legalHand = OpeningHandProbability.probabilityOfLegalHand(basics: basicPokemonCards)
		let supporterGivenLegal = OpeningHandProbability.probabilityOfSupporterGivenLegalHand(supporters: supporterCards)
		VStack(spacing: 3) {
			Text("Opening Probabilities")
				.font(.subheadline)
				.fontWeight(.bold)
				.fontDesign(.rounded)
			VStack(alignment: .leading) {
				Text("Legal hand probability: \(legalHand * 100, specifier: "%.2f")%")
				Text("And at least 1 Supporter Card: \(supporterGivenLegal * 100, specifier: "%.2f")%")
			}
			.font(.caption)
			.fontWeight(.bold)
			.padding()
			.frame(maxWidth: .infinity, alignment: .leading)
			.background {
				RoundedRectangle(cornerRadius: 12)
					.fill(.thinMaterial)
				
			}
		}
		.padding(.vertical, 5)
    }
}

#Preview {
	ProbabilityView(supporterCards: 10, basicPokemonCards: 10)
}
