//
//  PrizeCheckResult.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 17/12/2024.
//

import Foundation
import SwiftData

@Model
class PrizeCheckResult {
	var elapsedTime: TimeInterval
	var correctAnswer: Int
	var date: Date
	
	init(elapsedTime: TimeInterval, correctAnswer: Int, date: Date = .now) {
		self.elapsedTime = elapsedTime
		self.correctAnswer = correctAnswer
		self.date = date
	}
}
