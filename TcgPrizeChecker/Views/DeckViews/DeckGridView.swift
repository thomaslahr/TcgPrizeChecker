//
//  DeckGridView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 28/11/2024.
//

import SwiftUI
import SwiftData

struct DeckGridView: View {
	@Environment(\.modelContext) private var modelContext
	@Query var deck: [PersistentCard]
	@Binding var isShowingMessage: Bool
	
	@Query var decks: [Deck]
	let selectedDeckID: String
	let columns = [GridItem(.adaptive(minimum: 65))]
	var body: some View {
		ScrollView {
			Text("Press on a card to delete it from the deck")
			ZStack {
				LazyVGrid(columns: columns) {
					if let selectedDeck = decks.first(where: {$0.id == selectedDeckID}) {
						ForEach(selectedDeck.cards, id: \.uniqueId) { card in
							if let uiImage = UIImage(data: card.imageData) {
								Image(uiImage: uiImage)
									.resizable()
									.aspectRatio(contentMode: .fit)
									.frame(maxWidth: 75)
									.onLongPressGesture(minimumDuration: 0.2) {
										withAnimation {
											modelContext.delete(card)
											try? modelContext.save()
											print("Card was deleted from the deck.")
										}
										Task {
											await displayMessage()
										}
									}
							}
						}
					}
				}
			}
			.padding()
		}
	}
	@MainActor
	func displayMessage() async {
		isShowingMessage = true
		try? await Task.sleep(nanoseconds: 1_000_000_000)
		withAnimation {
			isShowingMessage = false
		}
	}
}

#Preview {
	DeckGridView(isShowingMessage: .constant(true), selectedDeckID: "3318B2A1-9A6E-4B34-884F-E8D52A5811A5")
}

// Den forrige versjonen av deck grid, når man ikke hadde mulighet til å ha flere decks.
//ForEach(deck, id: \.uniqueId) { card in
//	if let uiImage = UIImage(data: card.imageData) {
//		Image(uiImage: uiImage)
//			.resizable()
//			.aspectRatio(contentMode: .fit)
//			.frame(maxWidth: 75)
//			.onLongPressGesture(minimumDuration: 0.2) {
//				withAnimation {
//					modelContext.delete(card)
//					try? modelContext.save()
//					print("Card was deleted from the deck.")
//				}
//				Task {
//					await displayMessage()
//				}
//			}
//	}
//}
