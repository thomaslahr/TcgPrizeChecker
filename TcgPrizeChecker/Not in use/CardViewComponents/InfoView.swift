//
//  InfoView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 01/11/2024.
//

import SwiftUI

struct InfoView: View {
	
	let name: String
	let types: [EnergyType]?
	let category: Category
	let hp: Int
	let stage: String
	
	var body: some View {
		VStack(spacing: 0) {
			HStack {
				Text(name)
					.fontWeight(.bold)
				Spacer()
				HStack(spacing: 5) {
					if let types = types, !types.isEmpty && category == .pokemon {
						ForEach(types, id: \.rawValue) { type in
								HStack(spacing: 0) {
									Text("HP")
										.font(.caption)
										.fontWeight(.bold)
									Text("\(hp)")
								}
							
							ZStack {
								Circle()
									.frame(maxWidth: 22)
								
								type.symbol
									.resizable()
									.aspectRatio(contentMode: .fit)
									.frame(maxWidth: 20)
							}
						}
					}
					
				}
			}
			.foregroundStyle(.black)
			
			if category == .pokemon {
				Text("(\(stage.uppercased()))")
					.font(.caption)
					.fontWeight(.bold)
					.foregroundStyle(.black)
					.frame(maxWidth: .infinity, alignment: .leading)
			}
			
			
		}
	}
}

#Preview {
	InfoView(name: "Gardevoir ex", types: [.psychic], category: .pokemon, hp: 310, stage: "Stage2")
}
