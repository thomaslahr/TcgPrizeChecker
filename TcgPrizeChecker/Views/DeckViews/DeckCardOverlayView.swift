//
//  DeckCardOverlayView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 07/04/2025.
//

import SwiftUI

struct DeckCardOverlayView: View {
	
	@Environment(\.colorScheme) private var colorScheme
	
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
				HStack {
					Button {
						if let selectedDeck = decks.first(where: { $0.id == selectedDeckID }),
						   let index = currentCardIndex {
							let nextIndex = (index - 1) % selectedDeck.cards.count
							if currentCardIndex != 0 {
								currentCardIndex = nextIndex
							}
						}
					} label: {
						ZStack {
							Image(systemName: "arrow.backward.circle")
								.foregroundStyle(colorScheme == .dark ? .white : .black)
								.fontWeight(.bold)
								.opacity(currentCardIndex == 0 ? 0 : 1)
							RoundedRectangle(cornerRadius: 12)
								.frame(maxHeight: 100)
								.tint(.clear)
						}
					}
					.font(.system(size: 30))
					VStack {
						Text(selectedDeck.cards[currentCardIndex ?? 0].name)
							.frame(width: 250)
							.font(.title2)
							.fontWeight(.bold)
							.fontDesign(.rounded)
							.multilineTextAlignment(.center)
						
						Image(uiImage: uiImage)
							.resizable()
							.frame(width: 300, height: 400)
							.transition(.scale)
							.offset(y: cardOffset)
							.opacity(cardOpacity)
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
						Text("Card \((currentCardIndex ?? 0) + 1) of \(selectedDeck.cards.count)")
							.frame(width: 250)
							.font(.system(size: 15))
							.fontWeight(.bold)
							.fontDesign(.rounded)
							.multilineTextAlignment(.center)
							.padding(.top, 10)
					}
					Button {
						if let selectedDeck = decks.first(where: { $0.id == selectedDeckID }),
						   let index = currentCardIndex {
							let nextIndex = (index + 1) % selectedDeck.cards.count
							if currentCardIndex != selectedDeck.cards.count - 1 {
								currentCardIndex = nextIndex
							}
						}
					} label: {
						ZStack {
							Image(systemName: "arrow.forward.circle")
								.foregroundStyle(colorScheme == .dark ? .white : .black)
								.fontWeight(.bold)
								.opacity(currentCardIndex == selectedDeck.cards.count - 1 ? 0 : 1)
							RoundedRectangle(cornerRadius: 12)
								.frame(maxHeight: 100)
								.tint(.clear)
						}
					}
					.font(.system(size: 30))
				}
				.position(x: geometry.size.width / 2, y: geometry.size.height / 2.5)
			.frame(maxWidth: .infinity, maxHeight: .infinity)
		}
		.background(colorScheme == .dark ? .black.opacity(0.7) : .white.opacity(0.7)).ignoresSafeArea().opacity(cardOpacity)
    }
}

#Preview {
	DeckCardOverlayView(
		decks: [Deck.sampleDeck],
		selectedDeckID: "",
		currentCardIndex: .constant(1),
		selectedDeck: Deck.sampleDeck,
		uiImage: UIImage(imageLiteralResourceName: ""),
		cardOffset: .constant(0),
		cardOpacity: .constant(0),
		isDragging: .constant(false)
	)
}
