//
//  FifthOnboardingView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 21/04/2025.
//

import SwiftUI

struct FifthOnboardingView: View {
	@Environment(\.modelContext) private var modelContext
	@State private var userInput = ""
	@FocusState private var isTextFieldFocused: Bool
	@State private var textFieldBorderColor: Color = .blue
	
	@Binding var isLaunchingForTheFirstTime: Bool
	
	@State private var showLetters = false
	private let animatedText = "What are you currently playing?"
	
	var body: some View {
		
		let numberOfLetters = userInput.count
		
		ZStack {
			Color.clear
				.contentShape(Rectangle())
				.ignoresSafeArea(.keyboard)
				.onTapGesture {
					print("Clear background tapped")
					isTextFieldFocused = false
				}
			VStack {
				OnboardingTitleView(title: "Tap the textfield\nand let's get started!", fontSize: .title)
				
				TextField(text: $userInput.max(20)) {
					
				}
				
				.padding()
				.overlay(alignment: .leading) {
					if userInput.isEmpty {
						HStack(spacing: 0) {
							ForEach(Array(animatedText).indices, id: \.self) { index in
								Text(String(animatedText[animatedText.index(animatedText.startIndex, offsetBy: index)]))
									.foregroundStyle(.black.opacity(0.5))
									.opacity(showLetters ? 1 : 0)
									.animation(
										.easeInOut(duration: 0.1)
										.delay(Double(index) * 0.06), // Use index to stagger the delay
										value: showLetters
									)
							}
						}
						.padding()
						.allowsHitTesting(false)
					}
				}
				.foregroundStyle(.black)
				.focused($isTextFieldFocused)
				.overlay(alignment: .trailing) {
					Text("\(numberOfLetters)/15")
						.fontWeight(numberOfLetters > 15 ? .bold : .regular)
						.foregroundStyle(numberOfLetters > 15 ? .red : .primary.opacity(0.5))
						.padding(.trailing, 10)
					
				}
				.background {
					ZStack {
						RoundedRectangle(cornerRadius: 8)
							.fill(.white)
						RoundedRectangle(cornerRadius: 8)
							.stroke(lineWidth: 3)
							.foregroundStyle(isTextFieldFocused ? textFieldBorderColor : .primary.opacity(0.3))
							.animation(.easeIn(duration: 0.1), value: isTextFieldFocused)
					}
				}
				.autocorrectionDisabled(true)
				.padding(.horizontal, 10)
				
				Button {
					let newDeck = Deck(name: userInput)
					modelContext.insert(newDeck)
					try? modelContext.save()
					withAnimation(.easeInOut(duration: 0.5)){
						isLaunchingForTheFirstTime = false
					}
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
			}
		}
		.onAppear {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				showLetters = true
				
				DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
					isTextFieldFocused = true
				}
			}
		}
		.onChange(of: userInput) {
			let newColor: Color = numberOfLetters > 15 ? .red : .blue
			if newColor != textFieldBorderColor {
				textFieldBorderColor = newColor
			}
		}
	}
}

#Preview {
	FifthOnboardingView(isLaunchingForTheFirstTime: .constant(true))
}
