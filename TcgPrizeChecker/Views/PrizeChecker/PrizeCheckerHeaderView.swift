//
//  PrizeCheckerHeaderView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 18/12/2024.
//

import SwiftUI

struct PrizeCheckerHeaderView: View {
	@Binding var timer: TimerState
	@Binding var rotationAngle: Int
	@Binding var activeModal: PrizeModal?
	let hideTimer: Bool
	
    var body: some View {
		HStack {
			ZStack {
				Button {
					activeModal = .results
					print("Results button was pressed.")
				} label: {
					Image(systemName: "list.clipboard")
						.font(.system(size: 30))
				}
				.disabled(timer.isRunning)
				.padding(.leading, 20)
				.frame(maxWidth: .infinity, alignment: .leading)
				
				
				TimerView(
					timerString: $timer.string,
					isTimerRunning: $timer.isRunning,
					elapsedTime: $timer.elapsed,
					didTimerRunFor10min: $timer.ranFor10Min
				)
					.opacity(hideTimer ? 0 : 1)
					.animation(.linear(duration: 0.2), value: hideTimer)
					.frame(maxWidth: .infinity, alignment: .center)
				//.border(.red)
				
				Button {
					activeModal = .settings
					print("Settings button was pressed")
					withAnimation(.easeInOut(duration: 0.6)) {
						rotationAngle += 120
					}
					
				} label: {
					Image(systemName: "gear")
						.font(.system(size: 30))
						.rotationEffect(.degrees(Double(rotationAngle)))
				}
				.disabled(timer.isRunning)
				.padding(.trailing, 20)
				.frame(maxWidth: .infinity, alignment: .trailing)
			}
		}
		.frame(maxWidth: .infinity)
    }
}

#Preview {
	PrizeCheckerHeaderView(timer: .constant(TimerState()), rotationAngle: .constant(0), activeModal: .constant(.none), hideTimer: false)
}
