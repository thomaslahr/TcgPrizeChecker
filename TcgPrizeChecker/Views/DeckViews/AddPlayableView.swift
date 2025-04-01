//
//  AddPlayableView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 12/12/2024.
//

import SwiftUI
import SwiftData

struct AddPlayableView: View {
	@Environment(\.modelContext) private var modelContext
	@Environment(\.dismiss) private var dismiss
	@Query private var playableCards: [PlayableCard]
	@State private var isLongPress = false
	
	let columns = [GridItem(.adaptive(minimum: 80))]
	
	let selectedDeck: Deck?
	@State private var messageContent = ""
	@State private var isShowingMessage = false
	
	var body: some View {
		VStack{
			Text("Tap on a card to add it to a deck.")
			ZStack {
				LazyVGrid(columns: columns) {
					ForEach(playableCards, id: \.uniqueId) { card in
						Button {
							let newDeckCard = PersistentCard(
								imageData: card.imageData,
								id: card.id,
								localId: card.localId,
								name: card.name,
								uniqueId: UUID().uuidString
								
							)
							if let selectedDeck = selectedDeck {
								selectedDeck.cards.append(newDeckCard)
								modelContext.insert(newDeckCard)
								try? modelContext.save()
								messageContent = "\(card.name) was added to the \(selectedDeck.name) deck."
								Task {
									await displayMessage()
								}
							}
						} label: {
							if let uiImage = UIImage(data: card.imageData) {
								Image(uiImage: uiImage)
									.resizable()
									.aspectRatio(contentMode: .fit)
							}
						}
						.simultaneousGesture(LongPressGesture(minimumDuration: 0.2).onEnded { _ in
							print("This is a long press")
							withAnimation {
								modelContext.delete(card)
								try? modelContext.save()
							}
							print("The card should be deleted now?")
						})
					}
				}
				.padding(.horizontal, 10)
				MessageView(messageContent: messageContent)
					.opacity(isShowingMessage ? 1 : 0)
			}
		}
		.padding(.horizontal, 10)
		.padding(.vertical, 20)
	}
	@MainActor
	func displayMessage() async {
		print("Dislaying message")
		isShowingMessage = true
		try? await Task.sleep(nanoseconds: 1_500_000_000)
		withAnimation {
			isShowingMessage = false
		}
	}
}

#Preview {
	AddPlayableView(selectedDeck: nil)
}
