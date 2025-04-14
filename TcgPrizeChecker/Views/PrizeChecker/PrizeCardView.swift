//
//  PrizeCardView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 14/04/2025.
//

import SwiftUI

struct PrizeCardView: View {
	let prizeCard: PersistentCard
	let flipCard: Bool
	
	var body: some View {
		if let uiImage = UIImage(data: prizeCard.imageData) {
	
			(flipCard ? Image(uiImage: uiImage) : Image("cardBackMedium"))
				.resizable()
				.aspectRatio(contentMode: .fill)
				.padding(0)
				.frame(maxWidth: 100)
				.scaleEffect(x: flipCard ? -1 : 1, y: 1)
				.rotation3DEffect(.degrees(flipCard ? 180 : 0), axis: (x: 0.0, y: 1.0, z: 0.0))
		}
	}
}

//#Preview {
//	PrizeCardView(
//		prizeCard: PersistentCard(imageData: <#T##Data#>, id: <#T##String#>, localId: <#T##String#>, name: <#T##String#>, uniqueId: <#T##String#>),
//		flipCard: <#Bool#>
//	)
//}
