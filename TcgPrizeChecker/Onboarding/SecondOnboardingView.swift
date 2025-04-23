//
//  SecondOnboardingView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 20/04/2025.
//

import SwiftUI

struct SecondOnboardingView: View {
	
	@State private var currentStep = 0
	@Binding var currentPage: Int
	
	@State private var showLetters = false
	@State private var lettersCompleted = 0
	private let animatedText = "Search for cards to add to your deck"
	
	var body: some View {
		
		ZStack {
			RoundedRectangle(cornerRadius: 25)
				.fill(.clear)
				.shadow(radius: 5)
			
			VStack {
				//Step 1:
				VStack {
					OnboardingTitleView(title: "Searching for cards", fontSize: .title)
					HStack {
						Image(systemName: "magnifyingglass")
							.foregroundStyle(.white)
						HStack(spacing: 0) {
							ForEach(Array(animatedText).indices, id: \.self) { index in
								Text(String(animatedText[animatedText.index(animatedText.startIndex, offsetBy: index)]))
									.opacity(showLetters ? 1 : 0)
									.animation(
										.easeInOut(duration: 0.1)
										.delay(Double(index) * 0.03), // Use index to stagger the delay
										value: showLetters
									)
							}
						}
					}
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.horizontal, 7)
					.padding(.vertical, 10)
					.foregroundStyle(.gray)
					.background {
						ZStack {
							RoundedRectangle(cornerRadius: 9)
								.fill(.black)
							RoundedRectangle(cornerRadius: 9)
								.fill(.gray.opacity(0.2))
						}
					}
					.onAppear {
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
							showLetters = true
						}
					}
					
					if currentStep >= 1 {
						OnboardingLongerTextView(textBody: "Simply start typing in the textfield for the cards you're looking for.", fontSize: .subheadline)
							.padding(.vertical, 10)
							.transition(
								   .asymmetric(
									   insertion: AnyTransition.opacity
										   .combined(with: .offset(y: 25)),
									   removal: .opacity)
							   )
					}
				}
				.zIndex(1)

				.padding(.vertical, 10)
				
				// Step 2
					if currentStep >= 2 {
						VStack {
								HStack {
									ZStack {
										Circle().foregroundStyle(.blue)
											.frame(width: 40)
										Image(systemName: "plus").foregroundStyle(.white)
											.background {
											}
									}
									OnboardingLongerTextView(textBody: "Cards can then be added to a deck.", fontSize: .subheadline)
								}
						}
						.padding(.vertical, 10)
						.transition(
							   .asymmetric(
								   insertion: AnyTransition.opacity
									   .combined(with: .offset(y: 25)),
								   removal: .opacity)
						   )
						.frame(maxWidth: .infinity, alignment: .leading)
					
					
					if currentStep >= 3 {
						HStack {
							ZStack {
								Circle().foregroundStyle(GradientColors.primaryAppColor)
									.frame(width: 40)
								Image(systemName: "tray.2").foregroundStyle(.white)
									.background {
									}
							}
							Spacer()
							OnboardingLongerTextView(textBody: "Or they can be added as a Playable. When a card is added as a Playable it can be added to a deck later on without the app being connected to the internet.", fontSize: .subheadline)
						}
						.padding(.vertical, 10)
						.transition(
							   .asymmetric(
								   insertion: AnyTransition.opacity
									   .combined(with: .offset(y: 25)),
								   removal: .opacity)
						   )
						.frame(maxWidth: .infinity, alignment: .leading)
					}
					
				}
			}
		}
		.onChange(of: currentPage) {
			if currentPage == 1 {
				continueAnimation()
			}
		}
	}
	
	private func continueAnimation() {
		guard currentStep < 3 else { return }
		
		let delay = stepDelay(for: currentStep)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
			if currentPage == 1 {
				withAnimation(.easeInOut(duration: 1)) {
					currentStep += 1
				}
				continueAnimation()
			}
		}
	}
	
	private func stepDelay(for step: Int) -> Double {
		switch step {
		case 0:  return 2
		case 1: return 1.5
		case 2: return 1.5
		default: return 0
		}
	}
}

#Preview {
	SecondOnboardingView(currentPage: .constant(0))
}
