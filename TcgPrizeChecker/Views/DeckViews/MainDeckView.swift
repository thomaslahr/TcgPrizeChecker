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
	@StateObject var searchViewModel = SearchViewModel()
	@StateObject var allCardsViewModel = AllCardsViewModel()
	
	@Query var deck: [PersistentCard]
	@Query var decks: [Deck]
	
	@State private var uiState = UIState()
	@State private var testBinding = false
	
	@FocusState var isInputActive: Bool
	
	private var selectedDeck: Deck? {
		decks.first(where: { $0.id == deckSelectionViewModel.selectedDeckID})
	}
	
	var body: some View {
		NavigationStack {
			VStack {
				HStack{
					Image(systemName: "magnifyingglass")
						.padding(.leading, 5)
					TextField(text: $searchViewModel.searchText) {
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
					.onChange(of: searchViewModel.searchText) { oldValue, newValue in
						debounceSearch(newValue)
						//handleSearch(newValue)
					}
					.overlay(alignment: .trailing) {
						if !searchViewModel.searchText.isEmpty {
							Button {
								searchViewModel.searchText = ""
							} label: {
								Image(systemName: "x.circle.fill")
									.foregroundStyle(.gray)
								
							}
							.padding(.trailing, 10)
						}
					}
					if !isInputActive && searchViewModel.searchText.isEmpty {
						Button {
							withAnimation(.easeInOut(duration: 0.6)) {
								uiState.rotationAngle += 120
								uiState.showSettingsView.toggle()
							}
						} label: {
							Image(systemName: "gear")
								.font(.system(size: 27))
								.rotationEffect(.degrees(Double(uiState.rotationAngle)))
						}
					} else {
						Button("Cancel") {
							isInputActive = false
							searchViewModel.searchText = ""
						}
						.opacity(isInputActive || !searchViewModel.searchText.isEmpty ? 1 : 0)
						.animation(.easeIn(duration: 0.2), value: isInputActive)
					}
				}
				.padding(.horizontal, 15)
				
				// Hvis søketekst-feltet er tomt vises det nåværende decket. Bruker kan velge mellom list- eller gridview.
				if !isInputActive && searchViewModel.searchText.isEmpty {
					DeckActionsView(
						decks: decks,
						selectedDeck: selectedDeck,
						createDeck: $uiState.createDeck,
						isShowingMessage: $uiState.isShowingMessage,
						deleteDeck: $uiState.deleteDeck
					)
					
					DeckInfoView(viewSelection: $uiState.viewSelection, addPlayableCards: $uiState.addPlayableCards, decks: decks, selectedDeck: selectedDeck)
					
					switch uiState.viewSelection {
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
									  filteredCards: searchViewModel.results,
									  showImage: $uiState.showImage,
									  deckName: deckName,
									  selectedDeckID: deckSelectionViewModel.selectedDeckID ?? "",
									  searchText: searchViewModel.searchText,
									  isInputActive:  Binding<Bool>(get: { isInputActive }, set: { isInputActive = $0 }))
				}
			}
			.overlay {
					MessageView(messageContent: "You can only have 10 decks.")
					.opacity(uiState.isShowingMessage ? 1 : 0)
			}
//			To make sure the textfield doesn't lag upon user interaction whenever the app relaunches.
			.navigationTitle("Deck Overview")
			.navigationBarTitleDisplayMode(.inline)
		}
		// Playable cards er kommentert ut til appen har helt implementert muligheten til å ha flere deck
		.sheet(isPresented: $uiState.addPlayableCards) {
			PlayableMainView(selectedDeck: selectedDeck)
				.presentationContentInteraction(.scrolls)
		}
		.sheet(isPresented: $uiState.createDeck) {
			CreateDeckSheetView { newDeck in
				deckSelectionViewModel.selectedDeckID = newDeck.id
			}
				.presentationDetents([.medium])
		}
		.sheet(isPresented: $uiState.showSettingsView) {
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
	
	private func debounceSearch(_ query: String) {
		uiState.debounceTimer?.invalidate()
		uiState.debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) {_ in
			Task {
				await searchViewModel.performSearch(query: query, allCards: allCardsViewModel.cards)
			}
		}
	}
	private func validationSelection() {
		if deckSelectionViewModel.selectedDeckID == nil || !decks.contains(where: { $0.id == deckSelectionViewModel.selectedDeckID}) {
			deckSelectionViewModel.selectedDeckID = decks.first?.id
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


private struct UIState {
	var viewSelection = 0
	var debounceTimer: Timer?
	var rotationAngle = 0
	var addPlayableCards = false
	var createDeck = false
	var deleteDeck = false
	var showImage = false
	var showSettingsView = false
	var isShowingMessage = false
}
