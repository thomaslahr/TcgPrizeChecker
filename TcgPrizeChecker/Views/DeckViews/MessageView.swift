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
				
				
				Text(messageContent)
					.foregroundStyle(colorScheme == .dark ? .white : .black)
					.bold()
					.fontDesign(.rounded)
					.multilineTextAlignment(.leading)
					.frame(maxWidth: 230)
					.padding(30)
					.background {
						RoundedRectangle(cornerRadius: 20)
							.fill(.thinMaterial)
							.frame(maxWidth: gr.size.width - 100, maxHeight: 120)
							.shadow(color: .black.opacity(0.4), radius: 8, x: 5, y: 5)
					}
			
			.position(x: gr.size.width / 2, y: gr.size.height / 1.2)
			
			
			
		}
    }
}

#Preview {
	MessageView(messageContent: "The selected card was deleted from the deck. The selected card was deleted from the deck.")
}
