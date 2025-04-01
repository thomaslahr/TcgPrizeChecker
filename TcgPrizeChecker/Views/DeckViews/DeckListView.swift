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
	@Query private var deck: [PersistentCard]
	@Query private var decks: [Deck]
	let selectedDeckID: String?
	
	var body: some View {
	
		
		List {
			if let selectedDeck = decks.first(where: { $0.id == selectedDeckID}){
				ForEach(selectedDeck.cards, id: \.uniqueId) { card in
					HStack {
						VStack(alignment: .leading) {
							Text(card.name)
							if let cardSetName = CardSetName.fromCardSetID(card.id) {
								Text("(\(cardSetName.rawValue))")
							}
						}
						Spacer()
						if let uiImage = UIImage(data: card.imageData) {
							Image(uiImage: uiImage)
								.resizable()
								.aspectRatio(contentMode: .fit)
								.frame(maxWidth: 50)
							
						}
					}
				}
				.onDelete { indexSet in
					indexSet.forEach { index in
						modelContext.delete(selectedDeck.cards[index])
						try? modelContext.save()
					}
				}
			}
		}
	}
}

#Preview {
	DeckListView(selectedDeckID: "67799CE2-E41F-41AB-B38A-BEC7445F199E")
}
