//
//  PrizeCheckView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 28/11/2024.
//

import SwiftUI
import SwiftData

struct PrizeCheckView: View {
	@Environment(\.scenePhase) private var scenePhase
	@EnvironmentObject var deckSelectionViewModel: DeckSelectionViewModel
	@ObservedObject var imageCache: ImageCacheViewModel
	@Query var decks: [Deck]
	
	@StateObject private var prizeCheckViewModel = PrizeCheckViewModel()
	
	//Booleans for å vise sub views:
	
	//Booleans knyttet opp til endringer i settings subview:
	@State private var rotationAngle = 0
	
	//Variables knyttet opp til TimerView
	@StateObject var timerViewModel = TimerViewModel()
	@State private var deckSpacing: CGFloat = -72.0
	@State private var handSpacing: CGFloat = -72.0
	
	@State private var activeModal: PrizeModal?
	@State private var uiState = UIState()
	
	private var selectedDeck: Deck? {
		decks.first(where: { $0.id == deckSelectionViewModel.selectedDeckID})
	}
	
	@ObservedObject var deckViewModel: DeckViewModel
	
	var body: some View {
		NavigationStack {
			ZStack {
				if uiState.tappedDeck || uiState.tappedHand {
					Color.black.opacity(0.5) // Semi-transparent background
						.edgesIgnoringSafeArea(.all) // Make it cover the entire screen
						.transition(.opacity)
						.zIndex(0) // Put the overlay behind everything else
				}
				VStack {
					PrizeCheckerHeaderView(
						timerViewModel: timerViewModel,
						rotationAngle: $rotationAngle,
						activeModal: $activeModal,
						hideTimer: uiState.hideTimer
					)
					ScrollView {
						// Deck-picker-en øverst i viewet
						if deckSelectionViewModel.selectedDeckID != nil {
							HStack(spacing: 2) {
								Text("Current Deck:")
									.fontWeight(.semibold)
									.fontDesign(.rounded)
								CustomPickerMenuView(decks: decks)
									.disabled(timerViewModel.isRunning && !prizeCheckViewModel.deckState.cardsInHand.isEmpty)
							}
						}
						
						//"Hoveddelen av viewet hvor de tre radene med kort er.
						if !prizeCheckViewModel.deckState.cardsInHand.isEmpty {
							
							DeckAndHandView(
								deckSpacing: $deckSpacing,
								handSpacing: $handSpacing,
								tappedDeck: $uiState.tappedDeck,
								tappedHand: $uiState.tappedHand,
								isViewTapped: $uiState.isViewTapped,
								deck: prizeCheckViewModel.deckState,
								isRightCardOnTop: uiState.isRightCardOnTop
							)
							
							
							//Gjett hvilke kort som er prize cards.
							GuessPrizeCardsView(
								userGuesses: $prizeCheckViewModel.userGuesses,
								guessResult: $prizeCheckViewModel.guessResult,
								isTimerRunning: timerViewModel.isRunning
							)
							.opacity(uiState.tappedDeck || uiState.tappedHand ? 0 : 1)
							.padding()
						}
						
						if prizeCheckViewModel.deckState.cardsInHand.isEmpty && !uiState.showResultsPopover {
							ZStack {
								if deckViewModel.isLoadingDeck {
									LoadingDeckView(selectedDeck: selectedDeck, deckViewModel: deckViewModel)
								} else if let id = deckViewModel.lastRenderedDeckID {
									PrizeCheckDeckGridView(selectedDeckID: id, imageCache: imageCache)
										.transition(.opacity)
								}
							}
							.id(deckViewModel.lastRenderedDeckID) // Force fresh render on deck switch
							.animation(.easeInOut(duration: 0.35), value: deckViewModel.lastRenderedDeckID)
							.opacity(timerViewModel.isRunning ? 0 : 1)
						}
			
						if let selectedDeck = selectedDeck {
							if selectedDeck.cards.count < 14 {
								Text("There isn't enough cards in the deck yet to prize check.")
							}
						}
					}
					.scrollDisabled(uiState.tappedDeck || uiState.tappedHand)
					//Hvis brukeren endrer deck i f.eks MainDeckView, så nullstilles dette viewet, så det ikke vises noen kort. 17.12.24
					
					.onChange(of: deckSelectionViewModel.selectedDeckID) { oldValue, newValue in
						if !prizeCheckViewModel.deckState.cardsInHand.isEmpty {
							withAnimation {
								prizeCheckViewModel.fullViewReset()
							}
							print("The Cards in the Prize Checker was removed.")
						}
					}
					//Hvis bruker legger til eller sletter kort fra decket, så nullstilles også viewet. Mulig denne logikken kan slås sammen med den over?. 17.12.24
					.onChange(of: selectedDeck?.cards.count) { oldValue, newValue in
						if !prizeCheckViewModel.deckState.cardsInHand.isEmpty {
							withAnimation {
								prizeCheckViewModel.fullViewReset()
								
							}
							print("The Prize Checker was reset.")
						}
					}
					.onChange(of: scenePhase) { oldPhase, newPhase in
						if newPhase != .active && timerViewModel.isRunning {
							// App is no longer active → reset everything
							timerViewModel.stopAndReset()
							//timer.string = "0.00"
							print("App moved to background or became inactive — timer stopped and reset.")
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
					.onDisappear {
						prizeCheckViewModel.fullViewReset()
						
						timerViewModel.isRunning = false
						//timer.string = "0.00"
					}
					
					//Knappene nederst i viewet, over TabViewet.
					VStack(spacing: 10) {
						if selectedDeck?.cards.count ?? 0 > 60 {
							WarningTextView(text: "There's too many cards in the deck.", changeColor: true)
						}
						HStack {
							ZStack {
								Button {
									timerViewModel.isRunning = false
									prizeCheckViewModel.fullViewReset()
								} label: {
									Image(systemName: "x.circle")
										.font(.title)
										.fontWeight(.bold)
										.tint(.red)
										.animation(.linear(duration: 0.2), value: timerViewModel.isRunning)
								}
								.disabled(!timerViewModel.isRunning)
								.padding(.leading, 20)
								.frame(maxWidth: .infinity, alignment: .leading)
								
								Button {
									if timerViewModel.isRunning {
										//Submit
										prizeCheckViewModel.checkUserGuesses()
										//	showPrizeCards = true
										timerViewModel.isRunning = false
										uiState.showResultsPopover = true
									} else {
										//Shuffle
										prizeCheckViewModel.shuffleDeck(deck: selectedDeck)
										prizeCheckViewModel.resetDeck()
										timerViewModel.isRunning = true
									}
									
								} label: {
									Text(timerViewModel.isRunning ? "Submit" : "Shuffle Deck")
								}
								.buttonStyle(.borderedProminent)
								.frame(maxWidth: .infinity, alignment: .center)
								.disabled(selectedDeck?.cards.count ?? 0 < 14 || selectedDeck?.cards.count ?? 0 > 60)
								
								
								//Submit-kanppen er deaktivert hvis shuffle har blitt trykket på først. Mulig selve logikken her kan forenkles? 17.12.24
								
								Button {
									activeModal = .info
								} label: {
									Image(systemName: "info.circle")
										.font(.title)
								}
								.disabled(timerViewModel.isRunning)
								.padding(.trailing, 20)
								.frame(maxWidth: .infinity, alignment: .trailing)
							}
						}
					}
					.frame(maxWidth: .infinity)
					.sheet(item: $activeModal) { modal in
						switch modal {
						case .info:
							PrizeCheckerInfoSheet()
								.presentationDetents([.medium])
							
						case .settings:
							PrizeSettingsView(hideTimer: $uiState.hideTimer, isRightCardOnTop: $uiState.isRightCardOnTop)
								.presentationDetents([.medium])
							
						case .results:
							if let selectedDeck = selectedDeck {
								ResultsView(deck: selectedDeck)
							}
						}
					}
					.popover(isPresented: $uiState.showResultsPopover) {
						PopoverViewPrize(
							deckState: prizeCheckViewModel.deckState,
							prizeCheckViewModel: prizeCheckViewModel,
							selectedDeckID: deckSelectionViewModel.selectedDeckID ?? "",
							timerViewModel: timerViewModel)
						.interactiveDismissDisabled()
						.onAppear() {
							prizeCheckViewModel.fullViewReset()
						}
					}
				}
			}
			.navigationTitle("Prize Check")
			.navigationBarTitleDisplayMode(.inline)
			.alert("Timer stopped", isPresented: $timerViewModel.didTimerRunFor10min) {
				Button("OK", role: .cancel) { timerViewModel.didTimerRunFor10min = false }
			} message: {
				Text("The timer automatically stops after 10 minutes.")
			}
		}
	}
}

#Preview {
	
	NavigationStack{
		PrizeCheckView(
			imageCache: ImageCacheViewModel(),
			deckViewModel: DeckViewModel(
				imageCache: ImageCacheViewModel()
			)
		)
		.environmentObject(
			DeckSelectionViewModel()
		)
	}
}


//Denne knapper er for debugging og kan fjernes når app-en er ferdig. 17.12.24
//				Button("Show prizes") {
//					showPrizeCards.toggle()
//				}
//				.disabled(prizeCards.isEmpty)
//				.buttonStyle(.borderedProminent)
//En info knapp som trigger et sheet som enkelt forklarer hvordan prize checker-en funker.


//		for (index, userGuess) in userGuesses.enumerated() {
//			if userGuess.count > 2, prizeCards.contains(where: { $0.name.lowercased().contains(userGuess.lowercased())
//			})
//			{
//				guessResult[index] = .correct
//			} else {
//				guessResult[index] = .wrong
//			}
//		}

enum PrizeModal: Identifiable {
	case info
	case settings
	case results
	
	var id: Int { hashValue }
}

private struct UIState {
	var showResultsPopover = false
	var isRightCardOnTop = false
	var hideTimer = false
	var tappedDeck = false
	var tappedHand = false
	var isViewTapped = false
}

