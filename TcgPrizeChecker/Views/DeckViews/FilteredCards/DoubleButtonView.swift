//
//  DoubleButtonView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 05/04/2025.
//

import SwiftUI

struct DoubleButtonView: View {
	let allCardsViewModel: AllCardsViewModel
	@Binding var isButtonDisabled: Bool
	let card: Card
	@Binding var currentCard: Card?
	let selectedDeckID: String
	@Binding var isShowingMessage: Bool
	@Binding var wasCardAddedToDeck: Bool
	@Binding var wasCardAddedAsPlayable: Bool
	let deckName: String
	@Binding var messageContent: String
	let isHorizontal: Bool
	var body: some View {
			stack {
				ButtonView(
					card: card,
					allCardsViewModel: allCardsViewModel,
					buttonImage: "plus",
					foregroundColor: isButtonDisabled ? .gray : .blue,
					labelText: "Add Card To Deck",
					cardToSave: "Deck",
					deckName: deckName,
					selectedDeckID: selectedDeckID
				)
				//.disabled(decks.count == 4)
				
				ButtonView(
					card: card,
					allCardsViewModel: allCardsViewModel,
					buttonImage: "tray.2",
					foregroundColor: .red,
					labelText: "Add Card To Playables",
					cardToSave: "Playable",
					deckName: "Not to Deck",
					selectedDeckID: "Not deck"
				)
			}
			.simultaneousGesture(
				TapGesture().onEnded {
					Task {
						print("Button tapped")
						DispatchQueue.main.async {
							currentCard = card
							messageContent = wasCardAddedToDeck ? "\(currentCard?.name ?? "The card") was added to the \(deckName) deck." : "\(currentCard?.name ?? "The card") was added as a playable card."
						}
						showMessage()
					}
				}
			)
	}
	
	@ViewBuilder
	private func stack<Content: View>(@ViewBuilder content: () -> Content) -> some View {
		if isHorizontal {
			HStack { content() }
		} else {
			VStack { content() }
		}
	}
	
	private func showMessage() {
		isShowingMessage = true
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
			withAnimation {
				isShowingMessage = false
			}
		}
	}
}

//#Preview {
//	DoubleButtonView(allCardsViewModel: <#AllCardsViewModel#>, card: <#Card?#>)
//}
