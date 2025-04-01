//
//  MessageView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 13/12/2024.
//

import SwiftUI

struct MessageView: View {
//	@Binding var isShowingMessage: Bool
	@Environment(\.colorScheme) var colorScheme
	
	let messageContent: String
    var body: some View {
		GeometryReader{ gr in
			ZStack {
				RoundedRectangle(cornerRadius: 20)
					.fill(colorScheme == .dark ? .black : .white)
					.frame(maxWidth: gr.size.width - 100, maxHeight: 80)
					.shadow(color: .black.opacity(0.6), radius: 8, x: 5, y: 5)
					.overlay(
						ZStack {
							RoundedRectangle(cornerRadius: 8)
								.stroke(lineWidth: 2)
							RoundedRectangle(cornerRadius: 8)
								.stroke(lineWidth: 3)
								.scale(x: 0.97, y: 0.9)
						}
						)
				
				Text(messageContent)
					.foregroundStyle(colorScheme == .dark ? .white : .black)
					.bold()
					.fontDesign(.rounded)
					.multilineTextAlignment(.leading)
					.frame(maxWidth: 200)
			}
			.position(x: gr.size.width / 2, y: gr.size.height / 1.2)
			
			
			
		}
    }
}

#Preview {
	MessageView(messageContent: "The selected card was deleted from the deck.")
}
