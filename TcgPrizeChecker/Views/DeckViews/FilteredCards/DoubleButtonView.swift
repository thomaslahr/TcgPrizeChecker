//
//  DoubleButtonView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 05/04/2025.
//

import SwiftData
import SwiftUI

struct DoubleButtonView: View {
	@Environment(\.modelContext) private var modelContext
	let allCardsViewModel: AllCardsViewModel
	@Binding var isButtonDisabled: Bool
	let card: Card
	@Binding var currentCard: Card?
	let selectedDeckID: String
	@Binding var isShowingMessage: Bool
	let deckName: String
	@Binding var messageContent: String
	let isHorizontal: Bool
	let cardsInDeck: [PersistentCard]
	
	@State private var messageTask: Task <Void, Never>?
	@Query var decks: [Deck]
	@Query var playableCards: [PlayableCard]
	
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
						.foregroundStyle(.red)
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
	
	private func showMessage() {
		messageTask?.cancel()
		
		// Briefly hide the message if already showing
		isShowingMessage = false
		
		// Wait a small delay, then show and start countdown
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			withAnimation {
				isShowingMessage = true
			}
			
			// Start the countdown AFTER showing
			messageTask = Task {
				try? await Task.sleep(nanoseconds: 1_500_000_000)
				await MainActor.run {
					withAnimation {
						isShowingMessage = false
					}
				}
			}
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
				messageContent = "You can't add any more cards to the deck. \(card.name) was not added to the \(selectedDeck?.name ?? "") deck."
				showMessage()
				return
			}
			
			if copiesOfCard >= 4 {
				messageContent = "You can't add more than 4 copies of \(card.name)"
				showMessage()
				return
			}
			
		case .playable:
			let copiesOfCard = playableCards.filter { $0.id == card.id }.count
			
			if copiesOfCard >= 1 {
				messageContent = "You only need to add a card once to playables. \(card.name) was not added again."
				showMessage()
				return
			}
		}
		
		guard let imageData = try? await allCardsViewModel.downloadImage(from: imageURL) else { return }
		
		let cardToSave = (type == .deck) ? "Deck" : "Playable"
		let deck = (type == .deck) ? selectedDeck : Deck(name: "Not a deck")
		let deckNameToUse = (type == .deck) ? deckName : "Not to Deck"
		let deckIDToUse = (type == .deck) ? selectedDeckID : "Not deck"
		
		allCardsViewModel.saveImageToSwiftDataVM(
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
		
		messageContent = (type == .deck)
			? "\(card.name) was added to the \(deckName) deck."
			: "\(card.name) was added as a playable card."
		
		showMessage()
	}

}

//#Preview {
//	DoubleButtonView(allCardsViewModel: <#AllCardsViewModel#>, card: <#Card?#>)
//}
