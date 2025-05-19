//
//  PrizeCheckViewModel.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 14/04/2025.
//

import Foundation

class PrizeCheckViewModel: ObservableObject {
	@Published var deckState = DeckState()
	@Published var userGuesses: [String] = Array(repeating: "", count: 6)
	@Published var guessResult: [Answer] = Array(repeating: .guess, count: 6)
	@Published var tappedDeck = false
	@Published var tappedHand = false
	@Published var isViewTapped = false
	
	func shuffleDeck(deck: Deck?) {
		guard let cards = deck?.cards else {
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
	
	func resetDeck() {
		userGuesses = Array(repeating: "", count: 6)
		guessResult = Array(repeating: .guess, count: 6)
		//	showPrizeCards = false
	}
	
	func checkUserGuesses() {
		
		var unmatchedPrizeCards = deckState.prizeCards
		
		for (index, userGuess) in userGuesses.enumerated() {
			let cleanedGuess = userGuess.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
			
			guard !cleanedGuess.isEmpty, cleanedGuess.count > 2 else {
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
	
	func fullViewReset() {
//		guard !deckState.cardsInHand.isEmpty || !deckState.remainingCardsInDeck.isEmpty else {
//				return
//			}
		
		deckState.remainingCardsInDeck.removeAll()
		deckState.cardsInHand.removeAll()
		tappedDeck = false
		tappedHand = false
		isViewTapped = false
	}
	
	func startNewRound(with deck: Deck?) {
		shuffleDeck(deck: deck)
		resetDeck()
	}
}

