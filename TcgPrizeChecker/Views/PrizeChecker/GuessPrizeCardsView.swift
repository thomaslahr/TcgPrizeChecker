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
	
	//@FocusState private var focusedFieldIndex: Int?
	let isTimerRunning: Bool
	let focusedFieldIndex: FocusState<Int?>.Binding
	
	var body: some View {
		VStack {
			Text("Guess the Prize Cards:")
				.fontWeight(.semibold)
				.fontDesign(.rounded)
			ForEach(0..<userGuesses.count, id: \.self) { index in
				HStack {
					Image(systemName: "\(index + 1).circle")
						.font(.largeTitle)
						.foregroundStyle(GradientColors.primaryAppColor)
					
					TextField("Enter name of card:", text: $userGuesses[index], axis: .vertical)
						.lineLimit(1)
					//	.foregroundStyle(!isTimerRunning ? .gray : .primary)
						.focused(focusedFieldIndex, equals: index)
						.autocorrectionDisabled()
						.disabled(!isTimerRunning)
						.textFieldStyle(.plain)
						.submitLabel(index == userGuesses.count - 1 ? .done : .next)
						.onChange(of: userGuesses[index]) { oldValue, newValue in
							// Check if the user hit "return" (i.e. newline)
							if newValue.contains("\n") {
								userGuesses[index] = newValue.replacingOccurrences(of: "\n", with: "")
								// Move to next field, if any
								if index < userGuesses.count - 1 {
									focusedFieldIndex.wrappedValue = index + 1
								} else {
									focusedFieldIndex.wrappedValue = nil
								}
							}
						}
						.padding(10)
						.background {
							RoundedRectangle(cornerRadius: 8)
								.stroke(lineWidth: 2)
								.foregroundStyle(focusedFieldIndex.wrappedValue == index ? .blue : .gray)
								.animation(.easeIn(duration: 0.1), value: focusedFieldIndex.wrappedValue == index)
							
						}
					
//					Image(systemName: guessResult[index].sfSymbolText)
//						.font(.largeTitle)
//						.foregroundStyle(guessResult[index].sfSymbolColor)
				}
			}
		}
	}
}
//
//#Preview {
//	GuessPrizeCardsView(userGuesses: .constant(["Kirlia", "Ralts"]), guessResult: .constant([.correct, .wrong]), isTimerRunning: true, focusedFieldIndex: .constant(0))
//}
