//
//  PrizeCheckerHeaderView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 18/12/2024.
//

import SwiftUI

struct PrizeCheckerHeaderView: View {
	@Binding var showResultsView: Bool
	@Binding var isTimerRunning: Bool
	@Binding var timerString: String
	@Binding var elapsedTime: TimeInterval
	@Binding var showSettingsView: Bool
	@Binding var rotationAngle: Int
	
	let hideTimer: Bool
	
    var body: some View {
		HStack {
			ZStack {
				Button {
					showResultsView.toggle()
					print("Results button was pressed.")
				} label: {
					Image(systemName: "list.clipboard")
						.font(.title)
				}
				.disabled(isTimerRunning)
				.padding(.leading, 20)
				.frame(maxWidth: .infinity, alignment: .leading)
				
				
				TimerView(timerString: $timerString, isTimerRunning: $isTimerRunning, elapsedTime: $elapsedTime)
					.opacity(hideTimer ? 0 : 1)
					.animation(.linear(duration: 0.2), value: hideTimer)
					.frame(maxWidth: .infinity, alignment: .center)
				//.border(.red)
				
				Button {
					showSettingsView = true
					print("Settings button was pressed")
					withAnimation(.easeInOut(duration: 0.6)) {
						rotationAngle += 120
					}
					
				} label: {
					Image(systemName: "gear")
						.font(.largeTitle)
						.rotationEffect(.degrees(Double(rotationAngle)))
				}
				.disabled(isTimerRunning)
				.padding(.trailing, 20)
				.frame(maxWidth: .infinity, alignment: .trailing)
			}
		}
		.frame(maxWidth: .infinity)
    }
}

//#Preview {
//    PrizeCheckerHeaderView()
//}
