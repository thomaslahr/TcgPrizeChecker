//
//  DeckCardOverlayView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 07/04/2025.
//

import SwiftUI

struct DeckCardOverlayView: View {
	
	@Environment(\.colorScheme) private var colorScheme
	
	@State private var isNavigatingForward = false
	let decks: [Deck]
	let selectedDeckID: String
	@Binding var currentCardIndex: Int?
	let selectedDeck: Deck
	let uiImage: UIImage
	@Binding var cardOffset: CGFloat
	@Binding var cardOpacity: Double
	@Binding var isDragging: Bool
	var body: some View {
		GeometryReader { geometry in
			VStack {
				Text(selectedDeck.cards[currentCardIndex ?? 0].name)
					.frame(width: 250)
					.font(.system(size: geometry.size.width * 0.05))
					.fontWeight(.bold)
					.fontDesign(.rounded)
					.multilineTextAlignment(.center)
				
				Image(uiImage: uiImage)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(
						width: geometry.size.width * 0.5)
					.padding(.horizontal, 30)
				//.transition(.scale)
				
					.transition(.asymmetric(
						insertion: .move(edge: isNavigatingForward ? .leading : .trailing)
							.combined(with: .opacity),
						removal: .move(edge: isNavigatingForward ? .trailing : .leading)
							.combined(with: .opacity)))
				
					.id(currentCardIndex)
					.offset(y: cardOffset)
					.opacity(cardOpacity)
					.shadow(radius: 5)
					.onTapGesture {
						withAnimation(.linear(duration: 0.2)) {
							cardOpacity = 0  // Fade out first
						}
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
							currentCardIndex = nil // Remove after animation completes
							cardOpacity = 1  // Reset for next time
						}
					}
					.gesture(
						DragGesture()
							.onChanged { value in
								isDragging = true
								cardOffset = value.translation.height
							}
							.onEnded { value in
								if abs(value.translation.height) > 150 { // If swiped far enough
									withAnimation(.spring(response: 0.2, dampingFraction: 0.6, blendDuration: 0.1)) {
										cardOffset = 0
										currentCardIndex = nil
										
									}
								} else { // Snap back if not far enough
									withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.1)) {
										cardOffset = 0
									}
									isDragging = false
								}
							}
					)
				Text("Card \((currentCardIndex ?? 0) + 1) of \(selectedDeck.cards.count) in the deck")
					.shadow(radius: 5)
					.frame(width: 250)
					.font(.system(size: geometry.size.width * 0.035))
					.fontWeight(.bold)
					.fontDesign(.rounded)
					.multilineTextAlignment(.center)
					.padding(.top, 10)
			}
			.frame(maxWidth: .infinity)
			
			.opacity(cardOpacity)
			.position(x: geometry.size.width / 2, y: geometry.size.height / 2.5)
			.frame(maxWidth: .infinity, maxHeight: .infinity)
		}
		//		.background(colorScheme == .dark ? .black.opacity(0.7) : .white.opacity(0.7)).ignoresSafeArea().opacity(cardOpacity)
		//If opacity is 0, the grid underneath can still be interacted with.
		.background(.black.opacity(0.001)).ignoresSafeArea()
		.overlay {
			HStack {
				Button {
					if let selectedDeck = decks.first(where: { $0.id == selectedDeckID }),
					   let index = currentCardIndex {
						let nextIndex = (index - 1) % selectedDeck.cards.count
						if currentCardIndex != 0 {
							isNavigatingForward = true
							withAnimation(.easeIn(duration: 0.3)) {
								currentCardIndex = nextIndex
							}
						}
					}
				} label: {
					Image(systemName: "arrow.backward.circle")
						.font(.system(size: 30))
						.foregroundStyle(colorScheme == .dark ? .white : .black)
						.fontWeight(.bold)
						.opacity(currentCardIndex == 0 ? 0 : 1)
				}
				
				Spacer()
				//							Color.clear
				//								.frame(maxWidth: .infinity)
				
				Button {
					if let selectedDeck = decks.first(where: { $0.id == selectedDeckID }),
					   let index = currentCardIndex {
						let nextIndex = (index + 1) % selectedDeck.cards.count
						if currentCardIndex != selectedDeck.cards.count - 1 {
							isNavigatingForward = false
							withAnimation(.easeInOut(duration: 0.3)){
								currentCardIndex = nextIndex
							}
						}
					}
				} label: {
					Image(systemName: "arrow.forward.circle")
						.font(.system(size: 30))
						.foregroundStyle(colorScheme == .dark ? .white : .black)
						.fontWeight(.bold)
						.opacity(currentCardIndex == selectedDeck.cards.count - 1 ? 0 : 1)
				}
				
			}
			.opacity(cardOpacity)
			.padding(.horizontal, 10)
			//.frame(maxWidth: .infinity)
		}
	}
}

#Preview {
	let previewCard = Deck.sampleDeck.cards.first!
	let previewImage = UIImage(data: previewCard.imageData) ?? UIImage(systemName: "photo")!
	
	return DeckCardOverlayView(
		decks: [Deck.sampleDeck],
		selectedDeckID: Deck.sampleDeck.id,
		currentCardIndex: .constant(0),
		selectedDeck: Deck.sampleDeck,
		uiImage: previewImage,
		cardOffset: .constant(0),
		cardOpacity: .constant(1),
		isDragging: .constant(false)
	)
}
