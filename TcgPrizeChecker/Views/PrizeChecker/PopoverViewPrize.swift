//
//  PopoverViewPrize.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 17/12/2024.
//

import SwiftUI
import SwiftData

import SwiftUI
import SwiftData

struct PopoverViewPrize: View {
	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var modelContext
	
	let deckState: DeckState
	let columns = [GridItem(.flexible(), spacing: -30),GridItem(.flexible(), spacing: -30), GridItem(.flexible(), spacing: -30)]
	
	let prizeCheckViewModel: PrizeCheckViewModel

	
	let selectedDeckID: String
	
	let timerViewModel: TimerViewModel
	@State private var flipCard = false
	@State private var showText = false
	@State private var isAnimationDone = false
	
	var timeSpentDescription: String {
		let minutes = Int(timerViewModel.elapsed) / 60
		let seconds = Int(timerViewModel.elapsed) % 60
		
		if minutes == 0 {
			return "You spent \(seconds) second\(seconds == 1 ? "" : "s") prize checking."
		} else {
			return "You spent \(minutes) minute\(minutes == 1 ? "" : "s") and \(seconds) second\(seconds == 1 ? "" : "s") prize checking."
		}
	}
	var correctGuesses: [Answer] {
		prizeCheckViewModel.guessResult.filter { $0 == .correct }
	}
	
	var body: some View {
		
		VStack{
			Text(timeSpentDescription)
				.font(.title2)
				.bold()
				.multilineTextAlignment(.center)
				.frame(maxWidth: 300)
				.padding()
			
				VStack {
						LazyVGrid(columns: columns, spacing: 10) {
							ForEach(deckState.prizeCards, id: \.uniqueId) { prizeCard in
								PrizeCardView(prizeCard: prizeCard, flipCard: flipCard)
							}
						}
					}
			Text("You got \(correctGuesses.count) out of 6 prize cards right.")
				.font(.system(size: 18))
				.bold()
				.multilineTextAlignment(.center)
				.frame(maxWidth: 300)
				.padding(.vertical, 10)
				.opacity(showText ? 1 : 0)
				.animation(.easeIn(duration: 1.2), value: showText)
					
				VStack(spacing: 5) {
					ForEach(0..<prizeCheckViewModel.userGuesses.count, id: \.self) { index in
						HStack {
							HStack {
								Text("\(prizeCheckViewModel.userGuesses[index])")
								Spacer()
							}
							.padding(.horizontal)
							.padding(.vertical, 10)
							.background {
								RoundedRectangle(cornerRadius: 8)
									.stroke(lineWidth: 1)
							}
							Image(systemName: prizeCheckViewModel.guessResult[index].sfSymbolText)
								.font(.largeTitle)
								.foregroundStyle(prizeCheckViewModel.guessResult[index].sfSymbolColor)
						}
						
					}
				}
				.padding(.horizontal, 20)
			
			HStack {
				Button {
					handleOK()
				} label: {
					SimpleButtonView(buttonText: "OK", isButtonFilled: false)
				}
				.padding(.horizontal, 10)
				
				
				Button {
					handleSave()
				} label: {
					SimpleButtonView(buttonText: "Save result", isButtonFilled: true)
				}
				.padding(.horizontal, 10)
				
			}
			.disabled(!isAnimationDone)
			.padding(.top, 10)
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
	
	private func handleOK() {
		timerViewModel.string = "0.00"
		dismiss()
	}
	
	private func handleSave() {
		if let selectedDeck = try? modelContext.fetch(FetchDescriptor<Deck>()).first(where: { $0.id == selectedDeckID}) {
			
			let newResult = PrizeCheckResult(elapsedTime: timerViewModel.elapsed, correctAnswer: correctGuesses.count)
			
			selectedDeck.results.append(newResult)
			try? modelContext.save()
		}
			
		
		print("Result was saved to SwiftData!")
		timerViewModel.string = "0.00"
		dismiss()
	}
}

#Preview {
	PopoverViewPrize(deckState: DeckState(), prizeCheckViewModel: PrizeCheckViewModel(), selectedDeckID: "", timerViewModel: TimerViewModel())
}
