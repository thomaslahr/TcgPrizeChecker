//
//  TrainerInfoView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 01/11/2024.
//

import SwiftUI

struct TrainerInfoView: View {
	
	let trainerType: TrainerType
	let trainerCardEffect: String
	
	var body: some View {
		if !trainerType.rawValue.isEmpty  {
			VStack(alignment: .leading){
				HStack(spacing: 2) {
					Text("Trainer Card Type:")
						.font(.caption)
						.foregroundStyle(.black)
					Text("\(trainerType.rawValue)")
						.font(.caption).fontWeight(.black)
						.foregroundStyle(trainerType.trainerColor)
				}
				.padding(.bottom, 5)
				Text(trainerCardEffect)
					.font(.caption)
					.foregroundStyle(.black)
				
				
			}
		}
	}
}

#Preview {
	TrainerInfoView(
		trainerType: .item,
		trainerCardEffect: ""
		
	)
}


//struct TrainerInfoView: View {
//
//	@ObservedObject var cardViewModel: CardViewModel
//
//	var body: some View {
//		if let itemCard = cardViewModel.trainerType?.rawValue, !itemCard.isEmpty {
//			VStack(alignment: .leading){
//				HStack(spacing: 2) {
//					Text("Trainer Card Type:")
//						.font(.caption)
//					Text("\(cardViewModel.trainerType?.rawValue ?? "")")
//						.font(.caption).fontWeight(.black)
//						.foregroundStyle(cardViewModel.trainerType?.trainerColor ?? .black)
//				}
//				.padding(.bottom, 5)
//				Text(cardViewModel.effect ?? "")
//					.font(.caption)
//					.foregroundStyle(.black)
//
//
//			}
//		}
//	}
//}
//
//#Preview {
//	TrainerInfoView(cardViewModel: CardViewModel.sampleDataTrainer)
//}
