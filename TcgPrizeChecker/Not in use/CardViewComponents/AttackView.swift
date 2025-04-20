//
//  AttackView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 01/11/2024.
//

import SwiftUI

struct AttackView: View {
	
	let attacks: [Attack]
	
	var body: some View {
		if !attacks.isEmpty {
			ForEach(attacks, id: \.name) { attack in
					HStack(spacing: 3) {
						ForEach(attack.energyCost, id: \.self) { cost in
							ZStack {
								Circle()
									.frame(maxWidth: 22)
								cost.symbol
									.resizable()
									.aspectRatio(contentMode: .fit)
									.frame(maxWidth: 20)
							}
						}
						
						Text(attack.name)
							.foregroundStyle(.black)
							.fontWeight(.semibold)
							.padding(.leading, 10)
						Spacer()
						
					Text(attack.damage?.asString ?? "")
							.foregroundStyle(.black)
					}
					HStack {
						Text(attack.effect ?? "")
							.frame(maxWidth: .infinity, alignment: .leading)
							.font(.caption)
							.foregroundStyle(.black)
					}
			}
		}
	}
}

#Preview {
	AttackView(attacks: [Attack(energyCost: [.psychic, .psychic, .colorless], name: "Miracle Force", effect: "Damage", damage: DamageValue.int(190))])
}


//struct AttackView: View {
//	@ObservedObject var cardViewModel: CardViewModel
//	
//	let attacks: [Attack]
//	
//	var body: some View {
//		if let attacks = cardViewModel.attacks, !attacks.isEmpty {
//			ForEach(cardViewModel.attacks ?? [Attack(energyCost: [], name: "", effect: "", damage: DamageValue.int(70))], id: \.name) { attack in
//					HStack(spacing: 3) {
//						ForEach(attack.energyCost, id: \.self) { cost in
//							ZStack {
//								Circle()
//									.frame(maxWidth: 22)
//								cost.symbol
//									.resizable()
//									.aspectRatio(contentMode: .fit)
//									.frame(maxWidth: 20)
//							}
//						}
//						
//						Text(attack.name)
//							.foregroundStyle(.black)
//							.fontWeight(.semibold)
//							.padding(.leading, 10)
//						Spacer()
//						
//					Text(attack.damage?.asString ?? "")
//							.foregroundStyle(.black)
//					}
//					HStack {
//						Text(attack.effect ?? "")
//							.frame(maxWidth: .infinity, alignment: .leading)
//							.font(.caption)
//							.foregroundStyle(.black)
//					}
//			}
//		}
//	}
//}
