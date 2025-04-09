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
	@State private var rotationAngle = 0
	var cardFilters = ["sv"]
	
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
	@State private var isShowingMessage = false
	

	var body: some View {
		NavigationStack {
			VStack {
				HStack{
					Image(systemName: "magnifyingglass")
						.padding(.leading, 5)
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
							withAnimation(.easeInOut(duration: 0.6)) {
								rotationAngle += 120
								showSettingsView.toggle()
							}
						} label: {
							Image(systemName: "gear")
								.font(.system(size: 27))
								.rotationEffect(.degrees(Double(rotationAngle)))
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
					DeckActionsView(
						decks: decks,
						selectedDeck: selectedDeck,
						createDeck: $createDeck,
						isShowingMessage: $isShowingMessage,
						deleteDeck: $deleteDeck
					)
					
					DeckInfoView(viewSelection: $viewSelection, addPlayableCards: $addPlayableCards, decks: decks, selectedDeck: selectedDeck)
					
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
			.overlay {
					MessageView(messageContent: "You can only have 10 decks.")
						.opacity(isShowingMessage ? 1 : 0)
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
