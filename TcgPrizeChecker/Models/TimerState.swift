//
//  TimerState.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 08/04/2025.
//

import Foundation

struct TimerState {
	var isRunning: Bool = false
	var elapsed: TimeInterval = 0.0
	var string: String = "0.00"
	var ranFor10Min: Bool = false
}
