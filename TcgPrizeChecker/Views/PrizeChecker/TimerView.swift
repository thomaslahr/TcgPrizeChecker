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
	
	
	@ObservedObject var timerViewModel: TimerViewModel
	var body: some View {
		
		VStack{
			Text(timerViewModel.string)
				.font(.system(size: 30))
				.fontDesign(.rounded)
				.fontWeight(.bold)
				.onReceive(timer) { _ in
					if timerViewModel.isRunning {
						
						timerViewModel.elapsed = Date().timeIntervalSince(startTime)
						
						if timerViewModel.elapsed >= 600 {
							timerViewModel.isRunning = false
							timerViewModel.elapsed = 0
							timerViewModel.string = "0.00"
							timerViewModel.didTimerRunFor10min = true
						} else {
							let minutes = Int(timerViewModel.elapsed / 60)
							let seconds = timerViewModel.elapsed.truncatingRemainder(dividingBy: 60)
							timerViewModel.string = String(format: "%d.%02.0f", minutes, seconds)
						}
						
					}
				}
				.onAppear {
					if timerViewModel.isRunning {
						timerViewModel.string = "0.00"
						startTime = Date()
					}
				}
		}
		.onChange(of: timerViewModel.isRunning) {
			startTime = Date()
		}
		.onChange(of: timerViewModel.string) { oldValue, newValue in
			print("Timer fired")
		}
	}
}

#Preview {
	TimerView(timerViewModel: TimerViewModel())
}
