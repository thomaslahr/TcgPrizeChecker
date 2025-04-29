//
//  OpeningHandProbability.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 29/04/2025.
//

import Foundation

struct OpeningHandProbability {
	
	/// Calculates the probability of drawing at least one basic in a 7-card hand.
	static func probabilityOfLegalHand(basics: Int) -> Double {
		let totalCards = 60
		let handSize = 7
		return 1.0 - hypergeometricProbability(successesInPopulation: basics, draws: handSize, desiredSuccesses: 0, population: totalCards)
	}
	
	/// Calculates the probability of drawing at least one supporter in a 6-card hand,
	/// assuming one basic is already present.
	static func probabilityOfSupporterGivenLegalHand(supporters: Int) -> Double {
		let remainingCards = 59  // After one Basic is assumed drawn
		let draws = 6
		return 1.0 - hypergeometricProbability(successesInPopulation: supporters, draws: draws, desiredSuccesses: 0, population: remainingCards)
	}
	
	/// Core probability calculator using hypergeometric distribution.
	private static func hypergeometricProbability(successesInPopulation: Int, draws: Int, desiredSuccesses: Int, population: Int) -> Double {
		let successComb = combination(successesInPopulation, desiredSuccesses)
		let failureComb = combination(population - successesInPopulation, draws - desiredSuccesses)
		let totalComb = combination(population, draws)
		return (successComb * failureComb) / totalComb
	}
	
	/// Efficient combinatorics function (n choose k)
	private static func combination(_ n: Int, _ k: Int) -> Double {
		if k < 0 || k > n { return 0 }
		if k == 0 || k == n { return 1 }
		var result: Double = 1
		for i in 1...k {
			result *= Double(n - i + 1) / Double(i)
		}
		return result
	}
}
