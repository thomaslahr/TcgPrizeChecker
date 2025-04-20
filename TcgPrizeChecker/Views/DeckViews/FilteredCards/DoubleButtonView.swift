//
//  DoubleButtonView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 05/04/2025.
//

import SwiftData
import SwiftUI

struct DoubleButtonView: View {
	@EnvironmentObject private var messageManager: MessageManager
	@Environment(\.modelContext) private var modelContext
	let allCardsViewModel: AllCardsViewModel
	@Binding var isButtonDisabled: Bool
	let card: Card
	@Binding var currentCard: Card?
	let selectedDeckID: String
	let deckName: String
	let isHorizontal: Bool
	let cardsInDeck: [PersistentCard]
	
	@State private var messageTask: Task <Void, Never>?
	@Query var decks: [Deck]
	@Query var playableCards: [PlayableCard]
	
//	@Binding var isShowingMessage: Bool
//	@Binding var messageContent: String
	
	var body: some View {
		stack {
			Button {
				Task {
					await addCard(as: .deck)
				}
			} label: {
				ZStack {
					Circle()
						.foregroundStyle(isButtonDisabled ? .gray : .blue)
						.frame(maxWidth: 40)
					Label("Add card to deck", systemImage: "plus")
						.labelStyle(.iconOnly)
						.foregroundStyle(.white)
				}
			}
	
			Button {
				Task {
					await addCard(as: .playable)
				}
			} label: {
				ZStack {
					Circle()
						.foregroundStyle(GradientColors.primaryAppColor)
						.frame(maxWidth: 40)
					Label("Add Card to Playables", systemImage: "tray.2")
						.labelStyle(.iconOnly)
						.foregroundStyle(.white)
				}
			}
		}
	}
	
	@ViewBuilder
	private func stack<Content: View>(@ViewBuilder content: () -> Content) -> some View {
		if isHorizontal {
			HStack { content() }
		} else {
			VStack { content() }
		}
	}

	private func addCard(as cardSaveType: CardSaveType) async {
		currentCard = card
		let selectedDeck = decks.first(where: { $0.id == selectedDeckID })
		
		do {
			let message = try await allCardsViewModel.addCardToDeckOrPlayables(
				card: card,
				cardSaveType: cardSaveType,
				selectedDeckID: selectedDeckID,
				deckName: deckName,
				selectedDeck: selectedDeck,
				cardsInDeck: cardsInDeck,
				playableCards: playableCards,
				modelContext: modelContext
			)
			messageManager.messageContent = message
		} catch {
			messageManager.messageContent = error.localizedDescription
		}
		
		messageManager.showMessage()
	}

}

//#Preview {
//	DoubleButtonView(allCardsViewModel: <#AllCardsViewModel#>, card: <#Card?#>)
//}
