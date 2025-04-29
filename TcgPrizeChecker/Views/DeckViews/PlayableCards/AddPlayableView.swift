//
//  AddPlayableView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 12/12/2024.
//

import SwiftUI
import SwiftData

struct AddPlayableView: View {
	@EnvironmentObject private var messageManager: MessageManager
	@Environment(\.modelContext) private var modelContext
	@Environment(\.dismiss) private var dismiss
	@Query private var playableCards: [PlayableCard]
	
	@State private var isLongPress = false
	
	@State private var imageCache: [String: UIImage] = [:]  // 🔹 Image cache
	let columns =  [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]
	let selectedDeck: Deck?
	let cardsInDeck: [PersistentCard]
	@State private var hapticFeedbackAdd = false
	@State private var hapticFeedBackDelete = false
	
	var body: some View {
		VStack {
				ViewDescriptionTextView(text: playableCards.isEmpty ? "You haven't added any Playable cards yet." : "Tap on a card to add it to a deck.\n (Hold to delete it as a Playable card.")
			
			.fontWeight(.semibold)
			.fontDesign(.rounded)
			.padding(.bottom, 10)
			
			ScrollView {
				LazyVGrid(columns: columns) {
					ForEach(playableCards, id: \.uniqueId) { card in
						if let cachedImage = imageCache[card.uniqueId] {
							Image(uiImage: cachedImage)
								.resizable()
								.aspectRatio(contentMode: .fit)
								.frame(maxWidth: 110)
								.onTapGesture {
									hapticFeedbackAdd.toggle()
									let copiesOfCard = cardsInDeck.filter { $0.id == card.id }.count
									
									if copiesOfCard >= 4 {
										messageManager.messageContent = "You can't have more than 4 copies of a card in deck."
										messageManager.showMessage()
										return
									}
									addCardToDeck(card)
								}
								.onLongPressGesture {
									deleteCard(card)  // 🔹 Long press now only deletes
								}
								.addCardHapticFeedback(trigger: hapticFeedbackAdd)
						} else if let uiImage = UIImage(data: card.imageData) {
							Image(uiImage: uiImage)
								.resizable()
								.aspectRatio(contentMode: .fit)
								.frame(maxWidth: 110)
								.onTapGesture(perform: {
									hapticFeedbackAdd.toggle()
									addCardToDeck(card)
								})
								.onAppear { imageCache[card.uniqueId] = uiImage }
								.onLongPressGesture {
									hapticFeedBackDelete.toggle()
									deleteCard(card)  // 🔹 Long press now only deletes
								}
								.addCardHapticFeedback(trigger: hapticFeedbackAdd)
								.deleteCardHapticFeedback(trigger: hapticFeedBackDelete)
						}
						
					}
				}
				.padding(.horizontal, 10)
			}
			.scrollIndicators(.hidden)
			.overlay {
				MessageView(messageContent: messageManager.messageContent)
					.opacity(messageManager.isShowingMessage ? 1 : 0)
					.animation(.easeInOut(duration: 0.3), value: messageManager.isShowingMessage)
					.shadow(radius: 5)
			}
		}
		.overlay {
			if playableCards.isEmpty {
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
				.padding()
				.background {
					RoundedRectangle(cornerRadius: 12)
						.fill(.thinMaterial)
				}
			}
		}
		.padding(.horizontal, 10)
		.padding(.vertical, 20)
	}
	
	private func addCardToDeck(_ card: PlayableCard) {
		let copiesOfCard = cardsInDeck.filter { $0.id == card.id }.count
		
		guard let selectedDeck = selectedDeck else { return }
		
		let newDeckCard = PersistentCard(
			imageData: card.imageData,
			id: card.id,
			localId: card.localId,
			name: card.name,
			uniqueId: UUID().uuidString,
			category: card.category,
			trainerType: card.trainerType,
			stage: card.stage,
			evolveFrom: card.evolveFrom
		)
		
		selectedDeck.cards.append(newDeckCard)
		modelContext.insert(newDeckCard)
		try? modelContext.save()
		
		messageManager.messageContent = "\(card.name) was added to the \(selectedDeck.name) deck. (\(copiesOfCard + 1)/4)"
		messageManager.showMessage()
	}
	
	private func deleteCard(_ card: PlayableCard) {
		withAnimation {
			messageManager.messageContent = "\(card.name) was deleted as a playable card."
			modelContext.delete(card)
			try? modelContext.save()
			messageManager.showMessage()
		}
	}
	
	
}


#Preview {
	AddPlayableView(selectedDeck: nil, cardsInDeck: [])
		.environmentObject(MessageManager())
}
