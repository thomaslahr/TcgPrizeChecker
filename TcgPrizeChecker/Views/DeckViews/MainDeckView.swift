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
	@State private var deleteDeck = false
	@State private var debounceTimer: Timer?
	@State private var showImage = false
	@State private var showSettingsView = false
	var cardFilters = ["sv",
					   //"swsh9",
					   //"swsh10",
					   //"swsh10.5",
					   //"swsh11",
					   //"swsh12",
					   //"swsh12.5"
	]
	
	//Variabler som er direkte knyttet til deck-objekter:
	//Det er denne var-en som sendes rundt i appen
	//@State private var selectedDeckID: String?
	private var selectedDeck: Deck? {
		decks.first(where: { $0.id == deckSelectionViewModel.selectedDeckID})
	}
	@Query var decks: [Deck]
	@State private var testBinding = false
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
	@FocusState var isInputActive: Bool
	

	var body: some View {
		NavigationStack {
			VStack {
				HStack{
					Image(systemName: "magnifyingglass")
					TextField(text: $searchText) {
						Text("Search for cards to add")
							.foregroundStyle(.gray)
					}
					.focused($isInputActive)
					.autocorrectionDisabled(true)
					.padding(.leading, 7)
					.padding(.vertical, 8)
					.background {
						RoundedRectangle(cornerRadius: 8).fill(.gray.opacity(0.2))
							.background {
								RoundedRectangle(cornerRadius: 8)
									.stroke(lineWidth: 1)
									.foregroundStyle(isInputActive ? .blue : .clear)
									.animation(.easeIn(duration: 0.1), value: isInputActive)
							}
						
					}
					.onChange(of: searchText) { oldValue, newValue in
						debounceTimer?.invalidate()
						debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) {_ in
							Task {
								await performSearch(query: newValue)
							}
						}
						//handleSearch(newValue)
					}
					.overlay(alignment: .trailing) {
						if !searchText.isEmpty {
							Button {
								searchText = ""
							} label: {
								Image(systemName: "x.circle.fill")
									.foregroundStyle(.gray)
								
							}
							.padding(.trailing, 10)
						}
					}
					if !isInputActive && searchText.isEmpty {
						Button {
							showSettingsView.toggle()
						} label: {
							Image(systemName: "gear")
								.font(.system(size: 27))
						}
					} else {
						Button("Cancel") {
							isInputActive = false
							searchText = ""
						}
						.opacity(isInputActive || !searchText.isEmpty ? 1 : 0)
						.animation(.easeIn(duration: 0.2), value: isInputActive)
					}
				
				}
				.padding(.horizontal, 15)
				
				
				// Hvis søketekst-feltet er tomt vises det nåværende decket. Bruker kan velge mellom list- eller gridview.
				if !isInputActive && searchText.isEmpty {
					ZStack {
						HStack {
							Button {
								createDeck.toggle()
							} label: {
								Image(systemName: "plus.circle")
									.foregroundStyle(.green)
									.font(.title)
							}
							.frame(maxWidth: .infinity, alignment: .leading)
							.padding(.leading, 20)
						}
						HStack {
							if !decks.isEmpty {
								HStack(spacing: 0) {
									Picker("Choose deck", selection: $deckSelectionViewModel.selectedDeckID.bound(to: decks)) {
										ForEach(decks) { deck in
											Text(deck.name).tag(deck.id as String?)
										}
									}
								}
								//.frame(maxWidth: .infinity, alignment: .center)
							} else {
								HStack {
									Image(systemName: "arrow.left")
									Text("Create a deck to get started.")
								}
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
											.font(.title)
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
					
					Picker(selection: $viewSelection) {
						Text("List View").tag(0)
						Text("Grid View").tag(1)
					} label: {
						Text("Change View Type")
					}
					.pickerStyle(.segmented)
					
					HStack {
						
						// En enkel count for å holde styr på antall kort i decket.
						if let selectedDeck = selectedDeck {
							if selectedDeck.cards.count > 60 {
								Text("There's currently \(selectedDeck.cards.count) cards in the deck.")
									.padding(.leading, 10)
									.foregroundStyle(.red)
									.font(.caption)
									.fontWeight(.bold)
							} else {
								Text("There are \(selectedDeck.cards.count) cards in the deck.")
									.font(.caption)
									.fontWeight(.bold)
							}
							
							
						}
						Spacer()
						Button {
							addPlayableCards.toggle()
						} label: {
								Label("Playables", systemImage: "tray.2")
						}
						.buttonStyle(.borderedProminent)
						.padding(.horizontal)
						.disabled(decks.isEmpty)
					}
					.padding(.top, 10)
					switch viewSelection {
					case 0:
						DeckListView(selectedDeckID: deckSelectionViewModel.selectedDeckID)
					default:
						ZStack {
							DeckGridView(selectedDeckID: deckSelectionViewModel.selectedDeckID ?? "")
						}
					}

				} else {
					// deckName er kun for debugging, det trengs ikke for logikken som implementerer decks.
					let deckName = decks.first(where: {$0.id == deckSelectionViewModel.selectedDeckID})?.name ?? "No deck selected"
					
					FilteredCardsView(allCardsViewModel: allCardsViewModel,
									  filteredCards: results,
									  showImage: $showImage,
									  deckName: deckName,
									  selectedDeckID: deckSelectionViewModel.selectedDeckID ?? "",
									  searchText: searchText,
									  isInputActive:  Binding<Bool>(get: { isInputActive }, set: { isInputActive = $0 }))

				}
			}
//			To make sure the textfield doesn't lag upon user interaction whenever the app relaunches.
			.navigationTitle("Deck Overview")
			.navigationBarTitleDisplayMode(.inline)
		}
		// Playable cards er kommentert ut til appen har helt implementert muligheten til å ha flere deck
		.sheet(isPresented: $addPlayableCards) {
			PlayableMainView(selectedDeck: selectedDeck)
				.presentationContentInteraction(.scrolls)
		}
		.sheet(isPresented: $createDeck) {
			CreateDeckSheetView { newDeck in
				deckSelectionViewModel.selectedDeckID = newDeck.id
			}
				.presentationDetents([.medium])
		}
		.sheet(isPresented: $showSettingsView) {
			MainSettingsView()
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
		let lowerCasedQuery = query.lowercased()
		
		if lowerCasedQuery.isEmpty {
			await MainActor.run {
				results = []
				return
			}
		}
		let simulatedResults: [Card]
		
		if query.count == 1 {
			simulatedResults = filteredCards.filter { card in
				card.name.lowercased().hasPrefix(lowerCasedQuery)
			}
		} else {
			simulatedResults = filteredCards.filter { card in
				card.name.localizedCaseInsensitiveContains(query)
			}
		}
		
		await MainActor.run {
			results = simulatedResults
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
