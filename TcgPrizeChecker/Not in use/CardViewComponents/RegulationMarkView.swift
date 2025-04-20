//
//  RegulationMarkView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 06/11/2024.
//

import SwiftUI

struct RegulationMarkView: View {
	//@ObservedObject var cardViewModel: CardViewModel
	let regulationMark: String
	var body: some View {
		Text(regulationMark)
			.foregroundStyle(.black)
			.padding(2)
			.overlay {
				RoundedRectangle(cornerRadius: 4)
					.stroke(.black, lineWidth: 1)
			}
			.background {
				RoundedRectangle(cornerRadius: 4)
					.foregroundStyle(.white)
				
			}
	}
}
