//
//  DeckPartView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 01/12/2024.
//

import SwiftUI

struct DeckPartView: View {
	let whichCards: String
	let cards: [PersistentCard]
	let isRightCardOnTop: Bool
	let isCardsInHand: Bool
	@State private var showDeck = false
	
	@State private var flipCards = false
	var body: some View {
		VStack{
			Text("\(whichCards)")
				.bold()
			//		Button("Flip Cards") {
			//			withAnimation {
			//				showCards.toggle()
			//			}
			//		}
			ScrollView(.horizontal, showsIndicators: false) {
				HStack(spacing: -72) {
					ForEach(cards.indices, id: \.self) { index in
						VStack {
							if isCardsInHand {
								if let uiImage = UIImage(data: cards[index].imageData) {
									(flipCards ? Image(uiImage: uiImage) : Image("cardBackMedium"))
										.resizable()
										.scaledToFit()
										.frame(maxWidth: 108, maxHeight: 144)
										.scaleEffect(x: flipCards ? -1 : 1, y: 1)
										.rotation3DEffect(.degrees(flipCards ? -180 : 0), axis: (x: 0.0, y: 1.0, z: 0.0))
										.animation(.easeInOut(duration: 0.3).delay(Double(index) * 0.1), value: flipCards)
									
								} else {
									Text("No image avaliable.")
								}
							} else {
								if let uiImage = UIImage(data: cards[index].imageData) {
									Image(uiImage: uiImage)
										.resizable()
										.scaledToFit()
										.frame(maxWidth: 108, maxHeight: 144)
										.opacity(showDeck ? 1 : 0)
										.animation(.linear(duration: 0.5), value: showDeck)
									
								} else {
									Text("No image avaliable.")
								}
							}
							
						}
						.shadow(radius: 5)
						//.offset(x: CGFloat(index * 40), y: 1)
						.zIndex(isRightCardOnTop ? 0 : Double(cards.count - index))
						
						
					}
				}
				
				.onAppear {
					flipCards = true
					
					if !isCardsInHand {
						Task { @MainActor in
							try? await Task.sleep(nanoseconds: 1_000_000_000)
							withAnimation {
								showDeck = true
							}
						}
					}
				}
			}
			.frame(maxHeight: .infinity)
		}
	}
	
}

#Preview {
	DeckPartView(whichCards: "Cards in deck", cards: PersistentCard.sampleDeck, isRightCardOnTop: false, isCardsInHand: true)
}
