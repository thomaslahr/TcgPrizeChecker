//
//  EmptyDeckOverlayView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 27/04/2025.
//

import SwiftUI

struct EmptyDeckOverlayView: View {
    var body: some View {
		VStack(spacing: 15) {
			HStack {
				ZStack {
					Circle().foregroundStyle(.blue)
						.frame(width: 40)
					Image(systemName: "plus").foregroundStyle(.white)
						.background {
						}
				}
				ViewDescriptionTextView(text: "Tap this button when searching for cards\n to added it to a deck.")
			}
			.frame(maxWidth: .infinity)
			.padding()
			.background {
				RoundedRectangle(cornerRadius: 12)
					.fill(.thinMaterial)
					.shadow(radius: 2)
			}
			
			HStack {
				ZStack {
					Circle().foregroundStyle(GradientColors.primaryAppColor)
						.frame(width: 40)
					Image(systemName: "tray.2").foregroundStyle(.white)
						.background {
						}
				}
				ViewDescriptionTextView(text: "Tap this button when searching for cards\nif you want to store it as a Playable card.")
			}
			.frame(maxWidth: .infinity)
			.padding()
			.background {
				RoundedRectangle(cornerRadius: 12)
					.fill(.thinMaterial)
					.shadow(radius: 2)
			}
			
			VStack(alignment: .leading) {
			
				ViewDescriptionTextView(text: "You can add up to 65 cards in a deck, to have some flexibility when ")
				
				
			}
			.frame(maxWidth: .infinity)
			.padding()
			.background {
				RoundedRectangle(cornerRadius: 12)
					.fill(.thinMaterial)
					.shadow(radius: 2)
			}
		}
		.frame(maxWidth: 350)
    }
}

#Preview {
    EmptyDeckOverlayView()
}
