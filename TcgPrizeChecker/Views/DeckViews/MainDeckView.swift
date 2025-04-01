//
//  MainDeckView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 08/11/2024.
//

import SwiftUI
import SwiftData
import AsyncAlgorithms

struct MainDeckView: View {
	@Environment(\.modelContext) var modelContext
	@EnvironmentObject var deckSelectionViewModel: DeckSelectionViewModel
	//@ObservedObject var cardsetViewModel = CardSetViewModel()
	
	
	
	
	@Query var deck: [PersistentCard]
	@State private var addPlayableCards = false
	@State private var createDeck = false
	@State private var viewSelection = 0
	@State private var isShowingMessage = false
	@State private var deleteDeck = false
	var cardFilters = ["sv", "swsh9", "swsh10", "swsh10.5", "swsh11", "swsh12", "swsh12.5",]
	
	
	//Variabler som er direkte knyttet til deck-objekter:
	//Det er denne var-en som sendes rundt i appen
	//@State private var selectedDeckID: String?
	private var selectedDeck: Deck? {
		decks.first(where: { $0.id == deckSelectionViewModel.selectedDeckID})
	}
	@Query var decks: [Deck]
	
	// Denne (+ StateObject-et) kan kanskje flyttes inn med FilteredCardsView? 15.12.24
	var filteredCards: [Card] {
		let cards = allCardsViewModel.cards
		return cards.filter { card in
			cardFilters.contains(where: card.id.contains) &&
			(searchText.isEmpty || card.name.localizedStandardContains(searchText))
		}
	}
	
	@StateObject var allCardsViewModel = AllCardsViewModel()
	@State private var searchText = ""
	@State private var results: [Card] = []
	@State private var searchTask: Task<Void, Never>? = nil
	
	var body: some View {
		NavigationStack {
			VStack {
				HStack{
					Image(systemName: "magnifyingglass")
					TextField(text: $searchText) {
						Text("Search for cards to add")
							.foregroundStyle(.gray)
					}
					.padding(.vertical, 8)
					.background {
						RoundedRectangle(cornerRadius: 8).fill(.gray.opacity(0.2))
						
					}
					.onChange(of: searchText) { oldValue, newValue in
						handleSearch(newValue)
					}
				}
				.padding(.horizontal, 15)
				ZStack {
					HStack {
						if !decks.isEmpty {
							Picker("Choose deck", selection: $deckSelectionViewModel.selectedDeckID.bound(to: decks)) {
								ForEach(decks) { deck in
									Text(deck.name).tag(deck.id as String?)
								}
							}
							.frame(maxWidth: .infinity, alignment: .center)
						} else {
							Text("Create a deck to get started.")
								.frame(maxWidth: .infinity, alignment: .center)
						}
					}
					HStack {
						if decks.count > 0 {
							withAnimation {
								Button {
									deleteDeck.toggle()
								} label: {
									Image(systemName: "trash.circle")
										.opacity(searchText.isEmpty || !decks.isEmpty ? 1 : 0)
										.foregroundStyle(.red)
								}
								.alert("Are you sure you want to delete the deck?", isPresented: $deleteDeck) {
									Button("Cancel", role: .cancel) { }
									Button("Yes", role: .destructive) {
										if let selectedDeck = selectedDeck {
											modelContext.delete(selectedDeck)
											try? modelContext.save()
										}
									}
								}
							}
						}
					}
					.frame(maxWidth: .infinity, alignment: .trailing)
					.padding(.trailing, 20)
				}
				
				
				// Hvis søketekst-feltet er tomt vises det nåværende decket. Bruker kan velge mellom list- eller gridview.
				if searchText.isEmpty {
					Picker(selection: $viewSelection) {
						Text("List View").tag(0)
						Text("Grid View").tag(1)
					} label: {
						Text("Change View Type")
					}
					.pickerStyle(.segmented)
						
					switch viewSelection {
					case 0:
						DeckListView(selectedDeckID: deckSelectionViewModel.selectedDeckID)
					default:
						ZStack {
							DeckGridView(isShowingMessage: $isShowingMessage, selectedDeckID: deckSelectionViewModel.selectedDeckID ?? "")
							MessageView(messageContent: "The selected card was deleted from the deck.")
								.opacity(isShowingMessage ? 1 : 0)
						}
					}
					
					// En enkel count for å holde styr på antall kort i decket.
					if let selectedDeck = selectedDeck {
						Text("There are: \(selectedDeck.cards.count) cards in the deck.")
						if selectedDeck.cards.count > 60 {
							Text("There's currently too many cards in deck")
								.foregroundStyle(.red)
						}
						}
					
					
					HStack {
						//Trykk for å lage deck. Sendes til et nytt view (sheet).
						Button {
							createDeck.toggle()
						} label: {
							Text("Create Deck")
						}
						.buttonStyle(.borderedProminent)
						.padding(.horizontal)
						// Playable cards er kommentert ut til appen har helt implementert muligheten til å ha flere deck
						Button {
							addPlayableCards.toggle()
						} label: {
							Text("Add Playable Cards")
						}
						.buttonStyle(.borderedProminent)
						.padding(.horizontal)
						.disabled(decks.isEmpty)
					}
					
				} else {
					// deckName er kun for debugging, det trengs ikke for logikken som implementerer decks.
					let deckName = decks.first(where: {$0.id == deckSelectionViewModel.selectedDeckID})?.name ?? "No deck selected"
					
					FilteredCardsView(allCardsViewModel: allCardsViewModel, filteredCards: results, deckName: deckName, selectedDeckID: deckSelectionViewModel.selectedDeckID ?? "")
					
					.padding(.horizontal)
				}
			}
		//	.searchable(text: $searchText, prompt: "Search for cards to add")
			.navigationTitle("Decks")
			.navigationBarTitleDisplayMode(.inline)
		}
		// Playable cards er kommentert ut til appen har helt implementert muligheten til å ha flere deck
		.sheet(isPresented: $addPlayableCards) {
			PlayableMainView(selectedDeck: selectedDeck)
				.presentationContentInteraction(.scrolls)
		}
		.sheet(isPresented: $createDeck) {
			CreateDeckView()
				.presentationDetents([.medium])
		}
		.onAppear {
			validationSelection()
		}
		.onChange(of: decks) {
			validationSelection()
		}
	}

	private func validationSelection() {
		if deckSelectionViewModel.selectedDeckID == nil || !decks.contains(where: { $0.id == deckSelectionViewModel.selectedDeckID}) {
			deckSelectionViewModel.selectedDeckID = decks.first?.id
		}
	}
	
	private func handleSearch(_ query: String) {
		searchTask?.cancel()
		searchTask = Task {
			for await _ in [query].async.debounce(for: .milliseconds(300)) {
				await performSearch(query: query)
			}
		}
	}
	
	private func performSearch(query: String) async {
		try? await Task.sleep(nanoseconds: 1_000_000_000)
		
		let simulatedResults = filteredCards
		await MainActor.run {
			results = simulatedResults.filter { card in
				card.name.localizedCaseInsensitiveContains(query)
			}
		}
	}
}

extension Binding where Value == String? {
	func bound(to decks: [Deck]) -> Binding<String?> {
		Binding<String?>(
			get: {
				if let id = wrappedValue, decks.contains(where: { $0.id == id }) {
					return id
				}
				return decks.first?.id
			},
			set: { newValue in
				wrappedValue = newValue
			}
		)
	}
}

#Preview {
	MainDeckView()
		.environmentObject(DeckSelectionViewModel())
}



//Koden fra FilteredCardsViewet FØR refactoring. Kan slettes etterhvert. 15.12.24:

//					VStack {
//						Toggle(isOn: $showImage) {
//							Text("Show Image")
//						}
//
//						ScrollView {
//							Text("Number of returned cards: \(filteredCards.count)")
//							ForEach(filteredCards, id: \.id) { card in
//								HStack {
//									VStack(alignment: .leading) {
//										HStack {
//											Text(card.name)
//										}
//
//										if let cardSetName = CardSetName.fromCardSetID(card.id) {
//											Text("(\(cardSetName.rawValue))")
//										} else {
//											Text("")
//										}
//									}
//									Spacer()
//									if showImage {
//										AsyncImage(url: URL(string: "\(card.image ?? "")/low.webp")) { image in
//											image
//												.resizable()
//												.aspectRatio(contentMode: .fit)
//												.frame(maxWidth: 60)
//												.shadow(color: .black, radius: 3)
//										} placeholder: {
//											Image("cardBackMedium")
//												.resizable()
//												.aspectRatio(contentMode: .fit)
//												.frame(maxWidth: 60)
//										}
//									}
//
//									VStack {
//										ButtonView(
//											modelContext: modelContext,
//											card: card,
//											cardSetViewModel: cardsetViewModel,
//											buttonImage: "plus",
//											foregroundColor: .blue,
//											labelText: "Add Card To Deck",
//											cardToSave: "Deck"
//										)
//
//										ButtonView(
//											modelContext: modelContext,
//											card: card,
//											cardSetViewModel: cardsetViewModel,
//											buttonImage: "heart.fill",
//											foregroundColor: .red,
//											labelText: "Add Card To Playables",
//											cardToSave: "Playable"
//										)
//									}
//								}
//								Divider()
//							}
//						}
//						.task {
//							print("API call was made for all cards.")
//							await cardsetViewModel.fetchAllCards()
//						}
//					}

//Sørger for at default state-en til er et valgt deck.
//private func initializeSelection() {
//		if deckSelectionViewModel.selectedDeckID == nil, let firstDeck = decks.first {
//			deckSelectionViewModel.selectedDeckID = firstDeck.id
//			print(firstDeck.id)
//		}
//	
//	if deckSelectionViewModel.selectedDeckID == nil || !decks.contains(where: { $0.id == deckSelectionViewModel.selectedDeckID}){
//		deckSelectionViewModel.selectedDeckID = decks.first?.id
//	}
//}
