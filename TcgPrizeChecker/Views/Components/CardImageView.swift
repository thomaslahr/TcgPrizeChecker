//
//  CardImageView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 29/04/2025.
//

import SwiftUI

struct CardImageView: View {
	
	let image: UIImage
	let card: PlayableCard
	let isTapped: Bool
	let copiesOfCard: Int
	let onTap: () -> Void
	let onLongPress: () -> Void
	let hapticFeedbackTrigger: Bool
	
    var body: some View {
		Image(uiImage: image)
			.resizable()
			.aspectRatio(contentMode: .fit)
			.frame(maxWidth: 110)
			.scaleEffect(isTapped ? 1.1 : 1.0)
			.animation(.spring(duration: 0.2), value: isTapped)
			.onTapGesture(perform: onTap)
			.onLongPressGesture(perform: onLongPress)
			.addCardHapticFeedback(trigger: hapticFeedbackTrigger)
    }
}

//#Preview {
//	
//}
