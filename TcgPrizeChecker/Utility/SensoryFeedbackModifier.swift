//
//  SensoryFeedbackModifier.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 23/04/2025.
//

import SwiftUI

extension View {
	@ViewBuilder
	func addCardHapticFeedback(
		trigger: Bool) -> some View {
		self.sensoryFeedback(
			.impact(flexibility: .soft, intensity: 0.7), trigger: trigger)
	}
}

extension View {
	@ViewBuilder
	func deleteCardHapticFeedback(
		trigger: Bool) -> some View {
			self.sensoryFeedback(.success, trigger: trigger)
		}
}

