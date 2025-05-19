//
//  DeckListView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 28/11/2024.
//

import SwiftUI
import SwiftData

struct DeckListView: View {
	
	@Environment(\.modelContext) private var modelContext
	@Environment(\.dismiss) private var dismiss
	//	@ObservedObject var deckViewModel: DeckViewModel
	@Query private var decks: [Deck]
	let selectedDeckID: String?
	
	@ObservedObject var deckViewModel: DeckViewModel
	@ObservedObject var imageCache: ImageCacheViewModel
	
	private var selectedDeck: Deck? {
		decks.first(where: {$0.id == selectedDeckID})
	}
	var body: some View {
		List {
			if let selectedDeck {
				let sortedCards = deckViewModel.sortedCards(for: selectedDeck)
				
				ForEach(Array(sortedCards.enumerated()), id: \.element.uniqueId) { index, card in
					HStack {
						LazyVStack(alignment: .leading) {
							Text("\(card.dateAdded.formatted(date: .abbreviated, time: .shortened))")
								.font(.system(size: 10))
							Text(card.name)
								.fontWeight(.bold)
								.font(.system(size: 16))
								.foregroundStyle(Color.primary)
							
							HStack(spacing: 3) {
								if let category = card.category {
									Text("\(category)")
								}
								if let trainerType = card.trainerType {
									Text("(\(trainerType))")
										.font(.system(size: 12))
								}
								
								if let stage = card.stage {
									Text("(\(stage))")
										.font(.system(size: 12))
								}
							}
							.font(.system(size: 14))
							if let cardSetName = CardSetName.fromCardSetID(card.id) {
								Text("(\(cardSetName.rawValue))")
									.font(.system(size: 13))
							}
						}
						.foregroundStyle(.secondary)
						.fontDesign(.rounded)
						
						Spacer()
						
						if let cachedImage = imageCache.cache[card.uniqueId] {
							let isRevealed = imageCache.revealedCardIDs.contains(card.uniqueId)
							
							Image(uiImage: cachedImage)
								.resizable()
								.aspectRatio(contentMode: .fit)
								.frame(maxWidth: 50)
								.opacity(isRevealed ? 1 : 0)
								.onAppear {
									print("Cached image: \(index)")
									if !isRevealed {
										imageCache.revealCardInOrder(card, at: index)
									}
								}
						} else {
							if let uiImage = imageCache.loadImage(for: card) {
								let isRevealed = imageCache.revealedCardIDs.contains(card.uniqueId)
								
								Image(uiImage: uiImage)
									.resizable()
									.aspectRatio(contentMode: .fit)
									.frame(maxWidth: 50)
									.opacity(isRevealed ? 1 : 0)
									.onAppear {
										if !isRevealed {
											imageCache.revealCardInOrder(card, at: index)
										}
									}
							}						}
					}
					
				}
				.onDelete { indexSet in
					indexSet.map { sortedCards[$0] }.forEach { card in
						modelContext.delete(card)
					}
					try? modelContext.save()
				}
			}
		}
	}
}

#Preview {
	DeckListView(
		selectedDeckID: "67799CE2-E41F-41AB-B38A-BEC7445F199E",
		deckViewModel: DeckViewModel(
			imageCache: ImageCacheViewModel()
		),
		imageCache: ImageCacheViewModel()
	)
}
