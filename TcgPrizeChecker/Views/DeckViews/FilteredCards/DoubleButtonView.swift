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
	
	@State private var hapticTrigger = false
	@State private var isAddPressed = false
	@State private var isPlayablePressed = false
	
	var body: some View {
		
		let copiesOfCard = cardsInDeck.filter { $0.id == card.id }.count
		stack {
			Button {
				if copiesOfCard < 4 {
					isAddPressed = true
					
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
						isAddPressed = false
					}
				}
				Task {
					do {
						let message = try await addCard(as: .deck)
						// Only trigger animation and haptic if card was successfully added
						hapticTrigger.toggle()
						
						messageManager.messageContent = message
					} catch {
						// Show error but no haptic or animation
						messageManager.messageContent = error.localizedDescription
					}
					messageManager.showMessage()
				}
			} label: {
				ZStack {
					Circle()
						.foregroundStyle(copiesOfCard >= 4 || isButtonDisabled ? .gray : .blue)
						.frame(maxWidth: 40)
					Label("Add card to deck", systemImage: "plus")
						.labelStyle(.iconOnly)
						.foregroundStyle(.white)
				}
			}
			.scaleEffect(isAddPressed ? 1.15 : 1.0)
			.animation(.spring(duration: 0.2), value: isAddPressed)
			
			.addCardHapticFeedback(trigger: hapticTrigger)
			
			Button {
				isPlayablePressed = true
				
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
					isPlayablePressed = false
				}
				
				Task {
					do {
						let message = try await addCard(as: .playable)
						// Only trigger animation and haptic if card was successfully added
						hapticTrigger.toggle()
						
						messageManager.messageContent = message
					} catch {
						// Show error but no haptic or animation
						messageManager.messageContent = error.localizedDescription
					}
					messageManager.showMessage()
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
			.scaleEffect(isPlayablePressed ? 1.15 : 1.0)
			.animation(.spring(duration: 0.2), value: isPlayablePressed)
			.addCardHapticFeedback(trigger: hapticTrigger)
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
	
	private func addCard(as cardSaveType: CardSaveType) async throws -> String {
		currentCard = card
		let selectedDeck = decks.first(where: { $0.id == selectedDeckID })
		
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
		return message
	}
}

//#Preview {
//	DoubleButtonView(allCardsViewModel: <#AllCardsViewModel#>, card: <#Card?#>)
//}
