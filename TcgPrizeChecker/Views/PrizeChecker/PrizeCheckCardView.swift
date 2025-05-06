//
//  PrizeCheckCardView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 05/05/2025.
//

import SwiftUI

struct PrizeCheckCardView: View {
	let card: PersistentCard
		let index: Int
		let isCardsInHand: Bool
		let flipCards: Bool
		let showDeck: Bool
		let downscaledImageCache: [Int: UIImage]
		
		var body: some View {
			let image: UIImage? = {
				if isCardsInHand {
					if let original = UIImage(data: card.imageData) {
						return original.downscaled(to: CGSize(width: 432, height: 576))
					}
				} else {
					return downscaledImageCache[index]
				}
				return nil
			}()
			
			if let uiImage = image {
				ZStack {
					Color.clear.frame(maxHeight: 144)
					
					let imageView: some View = isCardsInHand
						? (flipCards ? Image(uiImage: uiImage) : Image("cardBackMedium"))
						: Image(uiImage: uiImage)
					
					imageView
						.resizable()
						.scaledToFit()
						.frame(maxWidth: 108, maxHeight: 144)
						.scaleEffect(x: isCardsInHand && flipCards ? -1 : 1, y: 1)
						.rotation3DEffect(
							.degrees(isCardsInHand && flipCards ? -180 : 0),
							axis: (x: 0.0, y: 1.0, z: 0.0)
						)
						.opacity(isCardsInHand ? 1 : (showDeck ? 1 : 0))
						.animation(
							isCardsInHand
								? .easeInOut(duration: 0.3).delay(Double(index) * 0.1)
								: .linear(duration: 0.5),
							value: isCardsInHand ? flipCards : showDeck
						)
						.shadow(radius: (index != 0 && index != downscaledImageCache.count - 1) ? 5 : 0)
				}
			}
		}
}

//#Preview {
//	PrizeCheckCardView(card: Deck.sampleDeck, index: <#Int#>, isCardsInHand: <#Bool#>, flipCards: <#Bool#>, showDeck: <#Bool#>, downscaledImageCache: <#[Int : UIImage]#>)
//}
