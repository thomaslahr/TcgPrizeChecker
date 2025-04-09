//
//  TimerView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 17/12/2024.
//

import SwiftUI

struct TimerView: View {
	@Environment(\.scenePhase) private var scenePhase
	@State private var startTime = Date()
	@State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	
	@Binding var timerString: String
	@Binding var isTimerRunning: Bool
	@Binding var elapsedTime: TimeInterval
	@Binding var didTimerRunFor10min: Bool
	var body: some View {
		
		VStack{
			Text(timerString)
				.font(.system(.title, design: .monospaced))
				.onReceive(timer) { _ in
					if isTimerRunning {
						
						elapsedTime = Date().timeIntervalSince(startTime)
						
						if elapsedTime >= 600 {
							isTimerRunning = false
							elapsedTime = 0
							timerString = "0.00"
							didTimerRunFor10min = true
						} else {
							let minutes = Int(elapsedTime / 60)
							let seconds = elapsedTime.truncatingRemainder(dividingBy: 60)
							timerString = String(format: "%d.%02.0f", minutes, seconds)
						}
						
					}
				}
				.onAppear {
					if isTimerRunning {
						timerString = "0.00"
						startTime = Date()
					}
				}
		}
		.onChange(of: isTimerRunning) {
			startTime = Date()
		}
		.onChange(of: timerString) { oldValue, newValue in
			print("Timer fired")
		}
	}
}

#Preview {
	TimerView(timerString: .constant("0.00"), isTimerRunning: .constant(false), elapsedTime: .constant(0.0), didTimerRunFor10min: .constant(false))
}
