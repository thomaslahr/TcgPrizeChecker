//
//  AbilityView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 01/11/2024.
//

import SwiftUI

struct AbilityView: View {
	
	let abilities: [Ability]
	
	var body: some View {
		if !abilities.isEmpty {
			ForEach(abilities, id: \.name) { ability in
				VStack(alignment: .leading) {
					HStack {
						Image(.abilityLabel)
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(maxWidth: 75)
							Text(ability.name)
								.foregroundStyle(.abilityRed)
								.fontWeight(.heavy)
					}
					HStack {
						// TODO: Bytte ut energi ord, Colorless, med colorless-symbol. Se Spidops 243, for eksempel.
						Text(ability.effect)
							.font(.caption)
							.foregroundStyle(.black)
					}
				}
			}
		}
	}
}

#Preview {
	AbilityView(abilities: [Ability(name: "Psychic Embrace", type: "", effect: "Energy")])
}
