//
//  ImageView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 01/11/2024.
//

import SwiftUI

struct ImageView: View {
	
	//@GestureState private var zoom = 1.0
	let image: String
	
	var body: some View {
		AsyncImage(url: URL(string: "\(image)/high.webp")) { image in
			image
			
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(maxWidth: 250)
				.shadow(color: .black, radius: 3)
				.padding(.bottom, 20)
		} placeholder: {
			ProgressView()
		}
		
	}
}

#Preview {
	ImageView(image: "")
}
