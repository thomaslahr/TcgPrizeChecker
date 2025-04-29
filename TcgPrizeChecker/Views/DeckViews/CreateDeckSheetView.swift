//
//  CreateDeckSheetView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 13/12/2024.
//

import SwiftUI
import SwiftData

struct CreateDeckSheetView: View {
	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var modelContext
	@State private var userInput = ""
	@FocusState private var isTextFieldFocused: Bool
	@State private var textFieldBorderColor: Color = .blue
	var onDeckCreated: (Deck) -> Void

	@State private var addCardHapticFeedback = false
	var body: some View {
		let numberOfLetters = userInput.count
		
		VStack {
			Text("Create a new deck")
				.font(.title)
				.fontDesign(.rounded)
				.padding()
			
			TextField("Enter name of your new deck", text: $userInput.max(25))
				.focused($isTextFieldFocused)
				.overlay(alignment: .trailing) {
					Text("\(numberOfLetters)/15")
						.fontWeight(numberOfLetters > 15 ? .bold : .regular)
						.foregroundStyle(numberOfLetters > 15 ? .red : .primary.opacity(0.3))
						.padding()
				}
				.padding()
				.background {
					RoundedRectangle(cornerRadius: 8)
						.stroke(lineWidth: 2)
						.foregroundStyle(isTextFieldFocused ? textFieldBorderColor : .primary.opacity(0.3))
						.animation(.easeIn(duration: 0.1), value: isTextFieldFocused)
				}
				.autocorrectionDisabled(true)
				.padding(.horizontal, 20)
				
			WarningTextView(text: "Deck name is too long..", changeColor: true)
				.opacity(numberOfLetters > 15 ? 1 : 0)
					.padding(.top, 10)
			
			Button {
				addCardHapticFeedback.toggle()
				let newDeck = Deck(name: userInput)
				modelContext.insert(newDeck)
				try? modelContext.save()
				onDeckCreated(newDeck)
				dismiss()
			} label: {
				Text("Create Deck")
					.foregroundStyle(.white)
			}
			.padding()
			.background {
				RoundedRectangle(cornerRadius: 12)
					.foregroundStyle(numberOfLetters > 15 || userInput.isEmpty ? .gray : .blue)
			}
			
			.disabled(userInput.isEmpty || userInput.count > 15)
			.addCardHapticFeedback(trigger: addCardHapticFeedback)
		}
		.onChange(of: userInput) {
			let newColor: Color = numberOfLetters > 15 ? .red : .blue
			if newColor != textFieldBorderColor {
				textFieldBorderColor = newColor
			}
		}
		.frame(maxHeight: .infinity)
		.background(.ultraThinMaterial)
		
	}
}

#Preview {
	CreateDeckSheetView(onDeckCreated: {_ in })
		.frame(height: 400)
}

extension Binding where Value == String {
	func max(_ limit: Int) -> Self {
		if self.wrappedValue.count > limit {
			DispatchQueue.main.async {
				self.wrappedValue = String(self.wrappedValue.dropLast())
			}
		}
		return self
	}
}
