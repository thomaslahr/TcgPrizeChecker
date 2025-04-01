//
//  FilteredCardsView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 13/12/2024.
//

import SwiftUI
import SwiftData
import AsyncAlgorithms

struct FilteredCardsView: View {
	@Environment(\.modelContext) private var modelContext
	@State private var showImage = false
	@ObservedObject var allCardsViewModel: AllCardsViewModel
	var filteredCards: [Card]
	@State private var isButtonDisabled = false
	@State private var isShowingMessage = false
	
	let deckName: String
	
	//Sendt inn fra MainDeckView
	let selectedDeckID: String
	
	@Query var decks: [Deck]
	
	var body: some View {
		ZStack {
			VStack {
				//Siden api kallet bruker mye data på fetching av bilder, så kan man velge hvorvidt man vil at det skal vises eller ikke.
				Toggle(isOn: $showImage) {
					Text("Show Image")
				}
				
				ScrollView {
					Text("Number of returned cards: \(filteredCards.count)")
					ForEach(filteredCards, id: \.id) { card in
						HStack {
							VStack(alignment: .leading) {
								HStack {
									Text(card.name)
								}
								
								//For å se hvilket set kortet tilhører.
								if let cardSetName = CardSetName.fromCardSetID(card.id) {
									Text("(\(cardSetName.rawValue))")
								} else {
									Text("")
								}
							}
							
							Spacer()
			
							if showImage {
								AsyncImage(url: URL(string: "\(card.image ?? "")/low.webp")) { image in
									image
										.resizable()
										.aspectRatio(contentMode: .fit)
										.frame(maxWidth: 60)
										.shadow(color: .black, radius: 3)
								} placeholder: {
									Image("cardBackMedium")
										.resizable()
										.aspectRatio(contentMode: .fit)
										.frame(maxWidth: 60)
								}
							}
							
							VStack {
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
								.disabled(decks.count == 4)
								.simultaneousGesture(
									TapGesture().onEnded {
										print("In on tap")
										Task {
											print("Button tapped")
											await displayMessage()
										}
									})
							
								
								ButtonView(
									card: card,
									allCardsViewModel: allCardsViewModel,
									buttonImage: "heart.fill",
									foregroundColor: .red,
									labelText: "Add Card To Playables",
									cardToSave: "Playable",
									deckName: "Not to Deck",
									selectedDeckID: "Not deck"
								)
							}
						}
						Divider()
					}
				}
				.task {
					print("API call was made for all cards.")
					await allCardsViewModel.fetchAllCards()
				}
			}
			if isButtonDisabled {
				MessageView(messageContent: "There is no deck,")
					.opacity(isShowingMessage ? 1 : 0)
			} else {
				MessageView(messageContent: "Card was added to deck.")
					.opacity(isShowingMessage ? 1 : 0)
			}
		}
		.onAppear {
			updateButtonState()
		}
	}
	private func updateButtonState() {
		if decks.count == 4 {
			isButtonDisabled = true
		} else {
			isButtonDisabled = false
		}
	}
	@MainActor
	func displayMessage() async {
		print("Dislaying message")
		isShowingMessage = true
		try? await Task.sleep(nanoseconds: 1_000_000_000)
		withAnimation {
			isShowingMessage = false
		}
	}
}

//#Preview {
//	FilteredCardsView()
//}
