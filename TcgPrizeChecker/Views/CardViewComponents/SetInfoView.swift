//
//  SetInfoView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 01/11/2024.
//

import SwiftUI

struct SetInfoView: View {
	//@ObservedObject var cardViewModel: CardViewModel
	
	let rarity: String
	let regulationMark: String?
	let cardSetShortName: String?
	let localId: String
	let cardCountOfficial: Int?
	let cardSetName: String?
	let id: String
	
	var body: some View {
		VStack(spacing: 1) {
			Text(rarity.capitalized)
				.foregroundStyle(.black)
			HStack(alignment: .lastTextBaseline) {
				if let regulationMark = regulationMark, !regulationMark.isEmpty {
					RegulationMarkView(regulationMark: regulationMark)
						.padding(.trailing, 5)
				}
				
				//Text(cardViewModel.cardSet?.name ?? "")
				
				
				CardSetLogo(cardSetShortName: cardSetShortName ?? "", id: id)
				Spacer()
				Text("\(localId)/\(cardCountOfficial ?? 0)")
					.foregroundStyle(.black)
				
				Spacer()
				Text(cardSetName ?? "")
					.foregroundStyle(.black)
			}
		}
		.padding(.horizontal, 25)
		.font(.caption)
		.fontWeight(.semibold)
	
	}
}


#Preview {
	SetInfoView(rarity: "Common", regulationMark: "H", cardSetShortName: "TWM", localId: "001", cardCountOfficial: 245, cardSetName: "Twilight Masquerade", id: "sv01-245")
}

