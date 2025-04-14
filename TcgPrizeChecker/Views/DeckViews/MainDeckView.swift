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
	@StateObject var searchViewModel = SearchViewModel(allCards: [])
	@StateObject var allCardsViewModel = AllCardsViewModel()
	@ObservedObject var imageCache: ImageCacheViewModel
	
	@ObservedObject var deckViewModel: DeckViewModel
	
	@Query var deck: [PersistentCard]
	@Query var decks: [Deck]
	
	@State private var uiState = UIState()
	@State private var testBinding = false
	
	@FocusState var isInputActive: Bool
	
	@State private var activeModal: DeckModal?
	
	private var selectedDeck: Deck? {
		decks.first(where: { $0.id == deckSelectionViewModel.selectedDeckID})
	}
	
	@State private var showProgressView = false
	
	
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
//					.onChange(of: searchViewModel.searchText) { oldValue, newValue in
//						searchViewModel.debounceSearch(query: newValue, allCards: allCardsViewModel.cards)
//						//handleSearch(newValue)
//					}
					.onChange(of: allCardsViewModel.cards) { _, newCards in
						searchViewModel.updateAllCards(newCards)
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
								activeModal = .settings
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
						isShowingMessage: $uiState.isShowingMessage,
						deleteDeck: $uiState.deleteDeck,
						activeModal: $activeModal
					)
					
					DeckInfoView(
						viewSelection: $uiState.viewSelection,
						decks: decks,
						selectedDeck: selectedDeck,
						activeModal: $activeModal
					)
					if uiState.viewSelection == 1 {
						Text("Tap on a card to enlarge, hold to delete it.")
							.font(.callout)
					}
					switch uiState.viewSelection {
					case 0:
						DeckListView(selectedDeckID: deckSelectionViewModel.selectedDeckID)
					default:
						if deckViewModel.isLoadingDeck {
							LoadingDeckView(selectedDeck: selectedDeck, deckViewModel: deckViewModel)
						} else if let id = deckViewModel.lastRenderedDeckID {
							ZStack {
								DeckGridView(imageCache: imageCache, selectedDeckID: id)
							}
			  .transition(.opacity)
			  .animation(.easeInOut(duration: 0.35), value: id)
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
			.onChange(of: deckSelectionViewModel.selectedDeckID) { _, newID in
				guard let newDeck = decks.first(where: { $0.id == newID }) else { return }
				
				deckViewModel.isLoadingDeck = true
				Task {
					await deckViewModel.preloadImages(for: newDeck)
					
					await MainActor.run {
						deckViewModel.readyDeckID = newID
						deckViewModel.lastRenderedDeckID = newID
						
						// Add a delay ONLY if the images were cached
						if deckViewModel.isDeckCached(newDeck) {
							DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
								deckViewModel.isLoadingDeck = false
							}
						} else {
							deckViewModel.isLoadingDeck = false
						}
					}
				}
				imageCache.revealedCardIDs.removeAll()
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
		.sheet(item: $activeModal) { modal in
			switch modal {
			case .playable:
				PlayableMainView(selectedDeck: selectedDeck)
					.presentationContentInteraction(.scrolls)
			case .create:
				CreateDeckSheetView { newDeck in
					deckSelectionViewModel.selectedDeckID = newDeck.id
				}
				.presentationDetents([.medium])
			case .settings:
				MainSettingsView()
					.presentationDetents([.medium])
			}
		}
		.onAppear {
			deckSelectionViewModel.validateDeckSelection(using: decks)
		}
		.onChange(of: decks) {
			deckSelectionViewModel.validateDeckSelection(using: decks)
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
	MainDeckView(imageCache: ImageCacheViewModel(), deckViewModel: DeckViewModel(imageCache: ImageCacheViewModel()))
		.environmentObject(DeckSelectionViewModel())
}


enum DeckModal: Identifiable {
	case playable
	case create
	case settings
	
	var id: Int { hashValue }
}
private struct UIState {
	var viewSelection = 0
	var rotationAngle = 0
	var deleteDeck = false
	var showImage = false
	var isShowingMessage = false
}
