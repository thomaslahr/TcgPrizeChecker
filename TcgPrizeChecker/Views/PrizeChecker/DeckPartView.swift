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
	@State private var spacing = -72.0
	
	@State private var flipCards = false
	@Binding var tappedDeck: Bool
	var body: some View {
		VStack {
				Text("\(whichCards)")
					.bold()

			.opacity(tappedDeck ? 0 : 1)
			
			ScrollView(.horizontal, showsIndicators: false) {
				LazyHStack(spacing: spacing) {
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
			
			HStack {
				Text("Change distance between cards")
					.font(.caption)
				Slider(value: $spacing,in: -72...0)
					.onChange(of: spacing) { oldValue, newValue in
						print("Spacing is: \(newValue)")
					}
			}
			.opacity(tappedDeck ? 0 : 1)
		}
		
	}
	
}

#Preview {
	DeckPartView(whichCards: "Cards in deck", cards: PersistentCard.sampleDeck, isRightCardOnTop: false, isCardsInHand: true, tappedDeck: .constant(false))
}
