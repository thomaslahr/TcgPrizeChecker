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
	@Binding var spacing: CGFloat
	
	@State private var flipCards = false
	@Binding var tappedDeck: Bool
	let isViewTapped: Bool
	
	@State private var cardOffsets: [CGFloat] = []
	
	@ObservedObject var imageCache: ImageCacheViewModel
	@State private var downscaledImageCache: [Int: UIImage] = [:]
	@State private var fullResImageCache: [Int: UIImage] = [:]
	
	var body: some View {
		VStack {
				Text("\(whichCards)")
					.bold()
			.opacity(tappedDeck ? 0 : 1)
			
			HStack {
				outerSpacer(forTappedState: isViewTapped)
				ScrollView(.horizontal, showsIndicators: false) {
					HStack {
						innerSpacer(forTappedState: isViewTapped)
						HStack(spacing: spacing) {
							ForEach(cards.indices, id: \.self) { index in
								VStack {
									if isCardsInHand {
										// Cards shown when this view is rendered as the hand
										if let original = UIImage(data: cards[index].imageData),
										   let uiImage = original.downscaled(to: CGSize(width: 432, height: 576)) {
											(flipCards ? Image(uiImage: uiImage) : Image("cardBackMedium"))
												.resizable()
												.scaledToFit()
												.frame(maxWidth: 108, maxHeight: 144)
												.scaleEffect(x: flipCards ? -1 : 1, y: 1)
												.rotation3DEffect(.degrees(flipCards ? -180 : 0), axis: (x: 0.0, y: 1.0, z: 0.0))
												.animation(.easeInOut(duration: 0.3).delay(Double(index) * 0.1), value: flipCards)
												.shadow(radius: (index != 0 && index != cards.count - 1) ? 5 : 0)
											
										} else {
											Text("No image avaliable.")
										}
									} else {
										//Cards shown when the view is rendered as the deck.
										if let uiImage =
//											isViewTapped ? fullResImageCache[index] :
												downscaledImageCache[index] {
											Image(uiImage: uiImage)
												.resizable()
												.scaledToFit()
												.frame(maxWidth: 108, maxHeight: 144)
												.opacity(showDeck ? 1 : 0)
												.animation(.linear(duration: 0.5), value: showDeck)
												.shadow(radius: (index != 0 && index != cards.count - 1) ? 5 : 0)
										} else {
											Text("No image avaliable.")
										}
									}
									
								}
								
								//.offset(x: CGFloat(index * 40), y: 1)
								.zIndex(isRightCardOnTop ? 0 : Double(cards.count - index))
							}
						}
						innerSpacer(forTappedState: isViewTapped)

					}
				}
				outerSpacer(forTappedState: isViewTapped)
			}

			HStack {
				Text("Change distance between cards")
					.font(.caption)
				Slider(value: $spacing,in: -72...0)
					.onChange(of: spacing) { oldValue, newValue in
						print("Spacing is: \(newValue)")
					}
			}
			.padding(.horizontal,5)
			.opacity(tappedDeck ? 0 : 1)
		}
//		.onChange(of: isViewTapped) {
//			loadFullResolutionImages()
//		}
		.onAppear {
			flipCards = true
			loadDownscaledImages()
			
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
	
	private func loadDownscaledImages() {
		for index in cards.indices {
			// Capture the card locally to avoid Sendable issues
			let card = cards[index]

			Task.detached(priority: .userInitiated) {
				// Copy image data in a thread-safe way
				let imageData = card.imageData

				guard let original = UIImage(data: imageData),
					  let downscaled = original.downscaled(to: CGSize(width: 432, height: 576)) else {
					return
				}

				// Set the image back on the main actor
				await MainActor.run {
					downscaledImageCache[index] = downscaled
				}

				// Slight delay to prevent spiking memory/CPU
				try? await Task.sleep(nanoseconds: 50_000_000) // 50ms
			}
		}
	}
	
//	private func loadFullResolutionImages() {
//		   for index in cards.indices {
//			   if fullResImageCache[index] == nil {
//				   if let original = UIImage(data: cards[index].imageData),
//					  let fullResImage = original.downscaled(to: CGSize(width: 324, height: 576)) {
//					   fullResImageCache[index] = fullResImage
//				   }
//				   print("Full res images is now live")
//			   }
//		   }
//	   }
	   
	
	private func outerSpacer(forTappedState tapped: Bool) -> some View {
		Color.clear.frame(width: tapped ? 85 : 0).opacity(0)
	}

	private func innerSpacer(forTappedState tapped: Bool) -> some View {
		Color.clear.frame(width: tapped ? 0 : 7).opacity(0)
	}
}

#Preview {
	DeckPartView(whichCards: "Cards in deck", cards: PersistentCard.sampleDeck, isRightCardOnTop: false, isCardsInHand: true, spacing: .constant(-72), tappedDeck: .constant(false), isViewTapped: false, imageCache: ImageCacheViewModel())
}

