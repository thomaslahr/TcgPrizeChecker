//
//  ButtonView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 13/12/2024.
//

import SwiftUI
import SwiftData

//struct ButtonView: View {
//	@Environment(\.modelContext) private var modelContext
//	let card: Card
//	let allCardsViewModel: AllCardsViewModel
//	let buttonImage: String
//	let foregroundColor: Color
//	let labelText: String
//	let cardToSave: String
//	let deckName: String
//	
//	//Relatert til deck-objekt
//	let selectedDeckID: String
//	@Query var decks: [Deck]
//	
//	var body: some View {
//		Button {
//			let imageURL = "\(card.image ?? "")/high.webp"
//			
//			Task {
//				do {
//					let selectedDeck = decks.first(where: {$0.id == selectedDeckID})
//					
//					let imageData = try await allCardsViewModel.downloadImage(from: imageURL)
//					
//					await allCardsViewModel
//						.saveImageToSwiftData(
//							info: CardSaveInfo(
//								imageData: <#T##Data#>,
//								id: <#T##String#>,
//								localId: <#T##String#>,
//								name: <#T##String#>,
//								cardToSave: <#T##String#>,
//								deckName: <#T##String#>,
//								selectedDeckID: <#T##String#>,
//								selectedDeck: <#T##Deck#>
//							),
//							modelContext: modelContext,
//						),
//					)
//					
//					
//				} catch {
//					print("Error downloading image: \(error.localizedDescription)")
//				}
//			}
//		} label: {
//			ZStack {
//				Circle()
//					.foregroundStyle(foregroundColor)
//					.frame(maxWidth: 40)
//				Label(labelText, systemImage: buttonImage)
//					.labelStyle(.iconOnly)
//					.foregroundStyle(.white)
//			}
//		}
//	}
//}

//#Preview {
//    ButtonView()
//}
