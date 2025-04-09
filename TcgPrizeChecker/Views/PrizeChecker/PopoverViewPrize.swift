//
//  PopoverViewPrize.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 17/12/2024.
//

import SwiftUI
import SwiftData

struct PopoverViewPrize: View {
	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var modelContext
	
	
	let deckState: DeckState
	let columns = [GridItem(.flexible(), spacing: -30),GridItem(.flexible(), spacing: -30), GridItem(.flexible(), spacing: -30)]
	
	let userGuesses: [String]
	var guessResult: [Answer]
	
	let selectedDeckID: String
	
	@Binding var elapsedTime: TimeInterval
	@State private var flipCard = false
	@State private var showText = false
	@State private var isAnimationDone = false
	
    var body: some View {
		let minutes = Int(elapsedTime) / 60
		let seconds = Int(elapsedTime) % 60
		
		VStack{
			let correctGuesses = guessResult.filter { answer in
				answer == .correct
			}
			var timeSpentDescription: String {
				if minutes == 0 {
					"You spent \(seconds) second\(seconds == 1 ? "" : "s") prize checking."
				} else {
					"You spent \(minutes) minute\(minutes == 1 ? "" : "s") and \(seconds) second\(seconds == 1 ? "" : "s") prize checking."
				}
			}
			Text(timeSpentDescription)
				.font(.title2)
				.bold()
				.multilineTextAlignment(.center)
				.frame(maxWidth: 300)
				.padding()
			
				VStack {
						LazyVGrid(columns: columns, spacing: 10) {
							ForEach(deckState.prizeCards, id: \.uniqueId) { prizeCard in
								if let uiImage = UIImage(data: prizeCard.imageData) {
							
									(flipCard ? Image(uiImage: uiImage) : Image("cardBackMedium"))
										.resizable()
										.aspectRatio(contentMode: .fill)
										.padding(0)
										.frame(maxWidth: 100)
										.scaleEffect(x: flipCard ? -1 : 1, y: 1)
										.rotation3DEffect(.degrees(flipCard ? 180 : 0), axis: (x: 0.0, y: 1.0, z: 0.0))
								}
							}
						}
					}
				
			ScrollView {
					Text("You got \(correctGuesses.count) out of 6 prize cards right.")
						.font(.title3)
						.bold()
						.multilineTextAlignment(.center)
						.frame(maxWidth: 300)
						.padding(.top, 20)
						.opacity(showText ? 1 : 0)
						.animation(.easeIn(duration: 1.2), value: showText)
				
				VStack {
					ForEach(0..<userGuesses.count, id: \.self) { index in
						HStack {
							HStack {
								Text("\(userGuesses[index])")
								Spacer()
							}
							.padding(.horizontal)
							.padding(.vertical, 10)
							.background {
								RoundedRectangle(cornerRadius: 12)
									.stroke(lineWidth: 2)
							}
							Image(systemName: guessResult[index].sfSymbolText)
								.font(.largeTitle)
								.foregroundStyle(guessResult[index].sfSymbolColor)
						}
						
					}
				}
				.padding(.horizontal, 20)
			}
			.labelsHidden()
			
			HStack {
				Button {
					dismiss()
				} label: {
					Text("OK")
						.padding()
						.frame(maxWidth: 120)
						.background {
							RoundedRectangle(cornerRadius: 8)
								.stroke(lineWidth: 2)
						}
						.tint(.primary)
				}
				.padding(.horizontal, 10)
				
				
				Button {
					
					if let selectedDeck = try? modelContext.fetch(FetchDescriptor<Deck>()).first(where: { $0.id == selectedDeckID}) {
						
						let newResult = PrizeCheckResult(elapsedTime: elapsedTime, correctAnswer: correctGuesses.count)
						
						selectedDeck.results.append(newResult)
						try? modelContext.save()
					}
						
					
					print("Result was saved to SwiftData!")
					dismiss()
					
				} label: {
					Text("Save")
						.padding()
						.frame(maxWidth: 120)
						.background {
							RoundedRectangle(cornerRadius: 8)
								.stroke(lineWidth: 2)
						}
						.tint(.primary)
				}
				.padding(.horizontal, 10)
				
			}
			.disabled(!isAnimationDone)
			.padding(.top, 30)
        }
		.onAppear {
			Task { @MainActor in
				try? await Task.sleep(nanoseconds: 700_000_000)
				withAnimation {
					flipCard = true
					showText = true
					isAnimationDone = true
				}
			}
		}
    }
}

#Preview {
	PopoverViewPrize(deckState: DeckState(), userGuesses: [], guessResult: [], selectedDeckID: "", elapsedTime: .constant(75.0))
}
