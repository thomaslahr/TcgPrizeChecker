//
//  BlurredBackgroundView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 02/11/2024.
//

import SwiftUI

struct BlurredBackgroundView: View {
	let cardNumber: String
	let image: String
	
    var body: some View {
		AsyncImage(url: URL(string: "\(image)/low.webp")) { image in
			image
				.resizable()
				.scaledToFill()
				.scaleEffect(1.75)
				.blur(radius: 30)
		} placeholder: {
			ProgressView()
		}
    }
}

#Preview {
	BlurredBackgroundView(cardNumber: "245", image: "")
}
