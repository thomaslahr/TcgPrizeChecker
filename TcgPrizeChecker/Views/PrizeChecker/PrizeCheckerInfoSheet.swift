//
//  PrizeCheckerInfoSheet.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 01/12/2024.
//

import SwiftUI

struct PrizeCheckerInfoSheet: View {
	@Environment(\.dismiss) private var dismiss
	var body: some View {
		VStack {
			Text("How to Check Prizes:")
				.font(.title3)
				.fontWeight(.bold)
				.padding(.bottom, 10)
			VStack(alignment: .leading) {
				Text("The text entered in the textfields need to be at least 3 letters long. But the cards full name doesn't have to written for the prize checker to work.")
			
				Text("For example: Entering 'ultra' will be approved as Ultra Ball. Or 'Char' will be recognized as Charizard ex/Radiant Charizard.")
					.padding(.top, 20)
				
					
			}
			.padding(.horizontal)
			Button {
				dismiss()
			} label: {
				Text("Dismiss")
			}
		}
		.font(.footnote)
	}
}

#Preview {
	PrizeCheckerInfoSheet()
}
