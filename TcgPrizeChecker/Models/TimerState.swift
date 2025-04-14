//
//  TimerState.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 08/04/2025.
//

import Foundation

class TimerViewModel: ObservableObject {
	@Published var isRunning: Bool = false
	@Published var elapsed: TimeInterval = 0.0
	@Published var string: String = "0.00"
	@Published var ranFor10Min: Bool = false
	@Published var didTimerRunFor10min: Bool = false
	
	func stopAndReset() {
		isRunning = false
		elapsed = 0.0
	}
}
