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
	
	var onDeckCreated: (Deck) -> Void

	var body: some View {
		VStack {
			Text("Create a new deck")
				.font(.title)
				.fontDesign(.rounded)
				.padding()
			TextField("Enter name of your new deck", text: $userInput)
				.focused($isTextFieldFocused)
				.padding()
				.background {
					RoundedRectangle(cornerRadius: 8)
						.stroke(lineWidth: 2)
						.foregroundStyle(isTextFieldFocused ? .blue : .primary.opacity(0.3))
						.animation(.easeIn(duration: 0.1), value: isTextFieldFocused)
				}
				.autocorrectionDisabled(true)
				.padding(.horizontal, 20)
			
				Text("Deck name is too long..")
					.font(.callout)
					.foregroundStyle(.red)
					.opacity(userInput.count > 20 ? 1 : 0)
			
			Button("Create Deck") {
				let newDeck = Deck(name: userInput)
				modelContext.insert(newDeck)
				try? modelContext.save()
				onDeckCreated(newDeck)
				dismiss()
			}
			.padding()
			.buttonStyle(.borderedProminent)
			.disabled(userInput.isEmpty || userInput.count > 20)
		}
		.frame(maxHeight: .infinity)
		.background(.ultraThinMaterial)
		
		
	}
}

#Preview {
	CreateDeckSheetView(onDeckCreated: {_ in })
		.frame(height: 400)
}
