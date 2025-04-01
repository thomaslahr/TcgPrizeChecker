//
//  PrizeCheckView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 28/11/2024.
//

import SwiftUI
import SwiftData

struct PrizeCheckView: View {
	
	@EnvironmentObject var deckSelectionViewModel: DeckSelectionViewModel
	@Query var decks: [Deck]
	
	//De tre array-ene som holder de ulike delene av decket ETTER det har blitt stokket.
	@State private var cardsInHand: [PersistentCard] = []
	@State private var prizeCards: [PersistentCard] = []
	@State private var remainingCardsInDeck: [PersistentCard] = []
	
	//Trigger tre av knappenes state.
	//@State private var showPrizeCards = false
	
	@State private var userGuesses: [String] = Array(repeating: "", count: 6)
	@State private var guessResult: [Answer] = Array(repeating: .guess, count: 6)
	
	//Booleans for å vise sub views:
	@State private var showInfoView = false
	@State private var showResultsPopover = false
	@State private var showResultsView = false
	@State private var showSettingsView = false
	
	//Booleans knyttet opp til endringer i settings subview:
	@State private var isRightCardOnTop = false
	@State private var rotationAngle = 0
	@State private var hideTimer = false
	
	//Variables knyttet opp til TimerView
	@State private var timerString = "0.00"
	@State private var isTimerRunning = false
	@State private var elapsedTime: TimeInterval = 0.0
	
	
	private var selectedDeck: Deck? {
		decks.first(where: { $0.id == deckSelectionViewModel.selectedDeckID})
	}
	
	var body: some View {
		NavigationStack {
			VStack {
				PrizeCheckerHeaderView(
					showResultsView: $showResultsView,
					isTimerRunning: $isTimerRunning,
					timerString: $timerString,
					elapsedTime: $elapsedTime,
					showSettingsView: $showSettingsView,
					rotationAngle: $rotationAngle,
					hideTimer: hideTimer
				)
				
				ScrollView {
					// Deck-picker-en øverst i viewet
					if deckSelectionViewModel.selectedDeckID != nil {
						DeckPickerView(decks: decks)
							.disabled(isTimerRunning && !cardsInHand.isEmpty)
					}
					
					//"Hoveddelen av viewet hvor de tre radene med kort er.
					if !cardsInHand.isEmpty {
						VStack {
							DeckPartView(whichCards: "Cards In Deck", cards: remainingCardsInDeck, isRightCardOnTop: isRightCardOnTop, isCardsInHand: false)
							
							DeckPartView(whichCards: "Cards In Hand", cards: cardsInHand, isRightCardOnTop: isRightCardOnTop, isCardsInHand: true)
						}
						.padding(.horizontal, 50)
						
						//Gjett hvilke kort som er prize cards.
						GuessPrizeCardsView(
							userGuesses: $userGuesses,
							guessResult: $guessResult,
							isTimerRunning: isTimerRunning
						)
						.padding()
					}
					
					if let selectedDeck = selectedDeck {
						if selectedDeck.cards.count < 14 {
							Text("There isn't enough cards in the deck yet to prize check.")
						}
					}
				}
				//Hvis brukeren endrer deck i f.eks MainDeckView, så nullstilles dette viewet, så det ikke vises noen kort. 17.12.24
				.onChange(of: deckSelectionViewModel.selectedDeckID) { oldValue, newValue in
					if !cardsInHand.isEmpty {
						withAnimation {
							fullViewReset()
						}
						print("The Cards in the Prize Checker was removed.")
					}
				}
				//Hvis bruker legger til eller sletter kort fra decket, så nullstilles også viewet. Mulig denne logikken kan slås sammen med den over?. 17.12.24
				.onChange(of: selectedDeck?.cards.count) { oldValue, newValue in
					if !cardsInHand.isEmpty {
						withAnimation {
							fullViewReset()
							
						}
						print("The Prize Checker was reset.")
					}
				}
				.onDisappear {
					isTimerRunning = false
				}
				//Knappene nederst i viewet, over TabViewet.
				HStack {
					ZStack {
						Button {
							isTimerRunning = false
						} label: {
							Image(systemName: "x.circle")
								.font(.title)
								.fontWeight(.bold)
								.tint(.red)
								.animation(.linear(duration: 0.2), value: isTimerRunning)
						}
						.disabled(!isTimerRunning)
						.padding(20)
						.frame(maxWidth: .infinity, alignment: .leading)
						
						Button {
							if isTimerRunning {
								//Submit
								checkUserGuesses()
								//	showPrizeCards = true
								isTimerRunning = false
								showResultsPopover = true
							} else {
								//Shuffle
								shuffleDeck()
								resetDeck()
								isTimerRunning = true
							}
							
						} label: {
							Text(isTimerRunning ? "Submit" : "Shuffle Deck")
								.foregroundStyle(.primary)
								.padding(.horizontal, 5)
								.padding(.vertical, 10)
								.background {
									RoundedRectangle(cornerRadius: 8)
										.fill(.blue)
										.frame(width: 150)
								}
						}
						.buttonStyle(.plain)
						.frame(maxWidth: .infinity, alignment: .center)
						.disabled(selectedDeck?.cards.count ?? 0 < 14)
						
						
						//Submit-kanppen er deaktivert hvis shuffle har blitt trykket på først. Mulig selve logikken her kan forenkles? 17.12.24
						
						Button {
							showInfoView.toggle()
						} label: {
							Image(systemName: "info.circle")
								.font(.title)
						}
						.disabled(isTimerRunning)
						.padding(20)
						.frame(maxWidth: .infinity, alignment: .trailing)
					}
				}
				.frame(maxWidth: .infinity)
				.sheet(isPresented: $showInfoView) {
					PrizeCheckerInfoSheet()
						.presentationDetents([.medium])
				}
				.sheet(isPresented: $showResultsView) {
					ResultsView()
				}
				.sheet(isPresented: $showSettingsView) {
					PrizeSettingsView(hideTimer: $hideTimer, isRightCardOnTop: $isRightCardOnTop)
						.presentationDetents([.medium])
				}
				.popover(isPresented: $showResultsPopover) {
					PopoverViewPrize(
						prizeCards: prizeCards,
						userGuesses: userGuesses,
						guessResult: guessResult,
						elapsedTime: $elapsedTime)
						.interactiveDismissDisabled()
						.onAppear() {
							fullViewReset()
						}
						
				}
			}
			//			.navigationTitle(isTimerRunning ? "" : "Prize Checker")
			//			.navigationBarTitleDisplayMode(.inline)
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
		cardsInHand = Array(shuffledDeck.prefix(7))
		remainingCardsInDeck = Array(shuffledDeck.dropFirst(13))
		prizeCards = Array(shuffledDeck[7...12])
	}
	
	private func resetDeck() {
		userGuesses = Array(repeating: "", count: 6)
		guessResult = Array(repeating: .guess, count: 6)
		//	showPrizeCards = false
	}
	
	private func checkUserGuesses() {
		
		var unmatchedPrizeCards = prizeCards
		
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
		remainingCardsInDeck.removeAll()
		cardsInHand.removeAll()
		//prizeCards.removeAll()
		//elapsedTime = 0.0
		timerString = "0.00"
	}
}

#Preview {
	
	NavigationStack{
		PrizeCheckView()
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
