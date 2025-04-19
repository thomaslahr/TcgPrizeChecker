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
	
	private enum CardSaveType {
		case deck, playable
	}

	private func addCard(as type: CardSaveType) async {
		let imageURL = "\(card.image ?? "")/high.webp"
		let selectedDeck = decks.first(where: { $0.id == selectedDeckID })
		currentCard = card
		
		switch type {
		case .deck:
			let copiesOfCard = cardsInDeck.filter { $0.id == card.id }.count
			
			if selectedDeck?.cards.count ?? 0 > 70 {
				messageManager.messageContent = "You can't add any more cards to the deck. \(card.name) was not added to the \(selectedDeck?.name ?? "") deck."
				messageManager.showMessage()
				return
			}
			
			if copiesOfCard >= 4 {
				messageManager.messageContent = "You can't have more than 4 copies of a card in deck."
				messageManager.showMessage()
				return
			}
			
		case .playable:
			let copiesOfCard = playableCards.filter { $0.id == card.id }.count
			
			if copiesOfCard >= 1 {
				messageManager.messageContent = "There already is a copy of this card in Playables. \(card.name) was not added again."
				messageManager.showMessage()
				return
			}
		}
		
		guard let imageData = try? await allCardsViewModel.downloadImage(from: imageURL) else { return }
		
		let cardToSave = (type == .deck) ? "Deck" : "Playable"
		let deck = (type == .deck) ? selectedDeck : Deck(name: "Not a deck")
		let deckNameToUse = (type == .deck) ? deckName : "Not to Deck"
		let deckIDToUse = (type == .deck) ? selectedDeckID : "Not deck"
		
		await allCardsViewModel.saveImageToSwiftDataVM(
			modelContext: modelContext,
			imageData: imageData,
			id: card.id,
			localId: card.localId,
			name: card.name,
			cardToSave: cardToSave,
			deckName: deckNameToUse,
			selectedDeckID: deckIDToUse,
			selectedDeck: deck ?? Deck(name: "Not a deck")
		)
		let copiesOfCard = cardsInDeck.filter { $0.id == card.id }.count
		
		messageManager.messageContent = (type == .deck)
			? "\(card.name) was added to the \(deckName) deck. (\(copiesOfCard + 1)/4)"
			: "\(card.name) was added as a playable card."
		
		messageManager.showMessage()
	}

}

//#Preview {
//	DoubleButtonView(allCardsViewModel: <#AllCardsViewModel#>, card: <#Card?#>)
//}
