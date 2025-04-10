//
//  GuessPrizeCardsView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 18/12/2024.
//

import SwiftUI

struct GuessPrizeCardsView: View {
	
	@Binding var userGuesses: [String]
	@Binding var guessResult: [Answer]
	
	@FocusState private var focusedFieldIndex: Int?
	let isTimerRunning: Bool
	
	var body: some View {
		VStack {
			Text("Guess the Prize Cards:")
				.fontWeight(.semibold)
				.fontDesign(.rounded)
			ForEach(0..<userGuesses.count, id: \.self) { index in
				HStack {
					TextField("Enter name of card:", text: $userGuesses[index])
					//	.foregroundStyle(!isTimerRunning ? .gray : .primary)
						.focused($focusedFieldIndex, equals: index)
						.autocorrectionDisabled()
						.disabled(!isTimerRunning)
						.textFieldStyle(.plain)
						.padding(10)
						
						.background {
							RoundedRectangle(cornerRadius: 8)
								.stroke(lineWidth: 2)
								.foregroundStyle(focusedFieldIndex == index ? .blue : .gray)
								.animation(.easeIn(duration: 0.1), value: focusedFieldIndex == index)
							
						}
					
					Image(systemName: guessResult[index].sfSymbolText)
						.font(.largeTitle)
						.foregroundStyle(guessResult[index].sfSymbolColor)
				}
			}
		}
	}
}

#Preview {
	GuessPrizeCardsView(userGuesses: .constant(["Kirlia", "Ralts"]), guessResult: .constant([.correct, .wrong]), isTimerRunning: true)
}
