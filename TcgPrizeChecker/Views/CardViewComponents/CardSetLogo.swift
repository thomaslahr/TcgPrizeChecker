//
//  CardSetLogo.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 03/11/2024.
//

import SwiftUI

struct CardSetLogo: View {
	let cardSetShortName: String
	let id: String
	
	var body: some View {
		if id.contains("sv") {
			ZStack {
				
				HStack(alignment: .lastTextBaseline, spacing: 0) {
					Text(cardSetShortName)
						.font(.system(size: 12, weight: .bold))
					
					Text("EN")
						.font(.system(size: 8, weight: .bold))
				}
				.foregroundStyle(.white)
				.padding(2)
				.background {
					RoundedRectangle(cornerRadius: 2)
						.frame(width: 51, height: 20)
						.foregroundStyle(.black)
					RoundedRectangle(cornerRadius: 2)
						.frame(width: 49, height: 18)
						.foregroundStyle(.white)
					RoundedRectangle(cornerRadius: 2)
						.frame(width: 47, height: 16)
						.foregroundStyle(.black)
				}
			}
		}
	}
}

#Preview {
	CardSetLogo(cardSetShortName: "TWN", id: "sv01")
}
