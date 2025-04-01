//
//  CreateDeckView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 13/12/2024.
//

import SwiftUI
import SwiftData

struct CreateDeckView: View {
	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var modelContext
	@State private var userInput = ""
	@FocusState private var isTextFieldFocused: Bool

	var body: some View {
		VStack {
			Text("Create a new deck")
				.font(.title)
				.fontDesign(.rounded)
				.padding()
			TextField("Enter name of new deck:", text: $userInput)
				.focused($isTextFieldFocused)
				.padding()
				.background {
					RoundedRectangle(cornerRadius: 8)
						.stroke(lineWidth: 2)
						.foregroundStyle(isTextFieldFocused ? .blue : .primary)
						.animation(.easeIn(duration: 0.1), value: isTextFieldFocused)
				}
				.autocorrectionDisabled(true)
				.padding(.horizontal, 20)
			Button("Create Deck") {
				let newDeck = Deck(name: userInput)
				modelContext.insert(newDeck)
				try? modelContext.save()
				dismiss()
			}
			.padding()
			.overlay {
				RoundedRectangle(cornerRadius: 8)
					.stroke(lineWidth: 2)
				RoundedRectangle(cornerRadius: 8)
					.stroke(lineWidth: 2)
					.scale(x: 1.08, y: 1.22)
			}
			.padding(20)
			.disabled(userInput.isEmpty)
		}
		.frame(maxHeight: .infinity)
		.overlay {
			RoundedRectangle(cornerRadius: 8)
				.stroke(lineWidth: 2)
			RoundedRectangle(cornerRadius: 8)
				.stroke(lineWidth: 2)
				.scale(x: 0.97, y: 0.97)
		}
		.padding()
		
		
	}
}

#Preview {
	CreateDeckView()
		.frame(height: 400)
}
