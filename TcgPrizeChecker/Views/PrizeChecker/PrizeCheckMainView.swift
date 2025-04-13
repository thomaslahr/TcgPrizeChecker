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
	
	
	//Trigger tre av knappenes state.
	//@State private var showPrizeCards = false
	
	@State private var userGuesses: [String] = Array(repeating: "", count: 6)
	@State private var guessResult: [Answer] = Array(repeating: .guess, count: 6)
	
	//Booleans for å vise sub views:
	
	//Booleans knyttet opp til endringer i settings subview:
	@State private var rotationAngle = 0
	
	//Variables knyttet opp til TimerView
	@State private var timer = TimerState()
	
	@State private var deckState = DeckState()
	
	
	@State private var deckSpacing: CGFloat = -72.0
	@State private var handSpacing: CGFloat = -72.0
	
	@State private var activeModal: PrizeModal?
	@State private var uiState = UIState()
	
	private var selectedDeck: Deck? {
		decks.first(where: { $0.id == deckSelectionViewModel.selectedDeckID})
	}
	
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
						timer: $timer,
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
									.disabled(timer.isRunning && !deckState.cardsInHand.isEmpty)
							}
						}
						
						//"Hoveddelen av viewet hvor de tre radene med kort er.
							if !deckState.cardsInHand.isEmpty {
				
									DeckAndHandView(
										deckSpacing: $deckSpacing,
										handSpacing: $handSpacing,
										tappedDeck: $uiState.tappedDeck,
										tappedHand: $uiState.tappedHand,
										isViewTapped: $uiState.isViewTapped,
										deck: deckState,
										isRightCardOnTop: uiState.isRightCardOnTop
									)
								
								
								//Gjett hvilke kort som er prize cards.
								GuessPrizeCardsView(
									userGuesses: $userGuesses,
									guessResult: $guessResult,
									isTimerRunning: timer.isRunning
								)
								.opacity(uiState.tappedDeck || uiState.tappedHand ? 0 : 1)
								.padding()
							}
							
						if deckState.cardsInHand.isEmpty && uiState.showResultsPopover == false {
								PrizeCheckDeckGridView(selectedDeckID: deckSelectionViewModel.selectedDeckID ?? "",
													   imageCache: imageCache)
									.opacity(timer.isRunning ? 0 : 1)
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
						if !deckState.cardsInHand.isEmpty {
							withAnimation {
								fullViewReset()
							}
							print("The Cards in the Prize Checker was removed.")
						}
					}
					//Hvis bruker legger til eller sletter kort fra decket, så nullstilles også viewet. Mulig denne logikken kan slås sammen med den over?. 17.12.24
					.onChange(of: selectedDeck?.cards.count) { oldValue, newValue in
						if !deckState.cardsInHand.isEmpty {
							withAnimation {
								fullViewReset()
								
							}
							print("The Prize Checker was reset.")
						}
					}
					.onChange(of: scenePhase) { oldPhase, newPhase in
						if newPhase != .active && timer.isRunning {
							// App is no longer active → reset everything
							timer.isRunning = false
							timer.elapsed = 0
							//timer.string = "0.00"
							print("App moved to background or became inactive — timer stopped and reset.")
						}
					}
					.onDisappear {
						fullViewReset()
						
						timer.isRunning = false
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
									timer.isRunning = false
									fullViewReset()
								} label: {
									Image(systemName: "x.circle")
										.font(.title)
										.fontWeight(.bold)
										.tint(.red)
										.animation(.linear(duration: 0.2), value: timer.isRunning)
								}
								.disabled(!timer.isRunning)
								.padding(.leading, 20)
								.frame(maxWidth: .infinity, alignment: .leading)
								
								Button {
									if timer.isRunning {
										//Submit
										checkUserGuesses()
										//	showPrizeCards = true
										timer.isRunning = false
										uiState.showResultsPopover = true
									} else {
										//Shuffle
										shuffleDeck()
										resetDeck()
										timer.isRunning = true
									}
									
								} label: {
									Text(timer.isRunning ? "Submit" : "Shuffle Deck")
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
								.disabled(timer.isRunning)
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
							deckState: deckState,
							userGuesses: userGuesses,
							guessResult: guessResult,
							selectedDeckID: deckSelectionViewModel.selectedDeckID ?? "",
							elapsedTime: $timer.elapsed, timerState: $timer)
						.interactiveDismissDisabled()
						.onAppear() {
							fullViewReset()
						}
						
					}
				}
			}
			.navigationTitle("Prize Check")
			.navigationBarTitleDisplayMode(.inline)
			.alert("Timer stopped", isPresented: $timer.ranFor10Min) {
				Button("OK", role: .cancel) { timer.ranFor10Min = false }
			} message: {
				Text("The timer automatically stops after 10 minutes.")
			}
			
			
		}
	}
	
	private func shuffleDeck() {
		guard let cards = selectedDeck?.cards else {
			print("No deck avaliable to shuffle.")
			return
		}
		let shuffledDeck = cards.shuffled()
		
		guard shuffledDeck.count >= 13 else {
			print("Not enough cards in the deck for prizes and and hand.")
			return
		}
		deckState.cardsInHand = Array(shuffledDeck.prefix(7))
		deckState.remainingCardsInDeck = Array(shuffledDeck.dropFirst(13))
		deckState.prizeCards = Array(shuffledDeck[7...12])
	}
	
	private func resetDeck() {
		userGuesses = Array(repeating: "", count: 6)
		guessResult = Array(repeating: .guess, count: 6)
		//	showPrizeCards = false
	}
	
	private func checkUserGuesses() {
		
		var unmatchedPrizeCards = deckState.prizeCards
		
		for (index, userGuess) in userGuesses.enumerated() {
			let cleanedGuess = userGuess.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
			
			guard !cleanedGuess.isEmpty else {
				guessResult[index] = .wrong
				continue
			}
			
			guard cleanedGuess.count > 2 else {
				guessResult[index] = .wrong
				continue
			}
			
			if let matchIndex = unmatchedPrizeCards.firstIndex(where: { $0.name.lowercased().contains(cleanedGuess)
			}) {
				guessResult[index] = .correct
				unmatchedPrizeCards.remove(at: matchIndex)
			} else {
				guessResult[index] = .wrong
			}
		}
		
		
	}
	
	private func fullViewReset() {
		deckState.remainingCardsInDeck.removeAll()
		deckState.cardsInHand.removeAll()
		//prizeCards.removeAll()
		//elapsedTime = 0.0
		//timer.string = "0.00"
	}
}

#Preview {
	
	NavigationStack{
		PrizeCheckView(imageCache: ImageCacheViewModel())
			.environmentObject(DeckSelectionViewModel())
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


