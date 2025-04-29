//
//  ThirdOnboardingView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 20/04/2025.
//

import SwiftUI

struct ThirdOnboardingView: View {
	@State private var currentStep = 0
	@Binding var currentPage: Int
	
	var body: some View {
		
		ZStack {
			RoundedRectangle(cornerRadius: 25)
				.fill(.clear)
				.shadow(radius: 5)
			
			VStack {
				//Step 1:
				VStack {
					OnboardingTitleView(title: "Creating decks", fontSize: .title)
						.padding()
					
					if currentStep >= 1 {
						HStack {
							Image(systemName: "plus.circle").foregroundStyle(.green)
								.font(.largeTitle)
							OnboardingLongerTextView(textBody: "Decks can be created.", fontSize: .headline)
						}
						.transition(
							   .asymmetric(
								   insertion: AnyTransition.opacity
									   .combined(with: .offset(y: 25)),
								   removal: .opacity)
						   )
						.frame(maxWidth: .infinity, alignment: .leading)
						
					}
					
				}
				.padding(.vertical, 10)
				
				// Step 2
				VStack {
					if currentStep >= 2 {
						HStack {
								Image(systemName: "trash.circle").foregroundStyle(.red)
								.font(.largeTitle)
							
							OnboardingLongerTextView(textBody: "And deleted.", fontSize: .headline)
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
					
					if currentStep >= 3 {
						HStack(spacing: 10) {
							ZStack {
								RoundedRectangle(cornerRadius: 8)
								.foregroundStyle(GradientColors.primaryAppColor)
									.frame(width: 33, height: 33)
								Image(systemName: "tray.2").foregroundStyle(.white)
									.font(.title2)
							}
							OnboardingLongerTextView(textBody: "Basic Energy cards and your Playables are found here.", fontSize: .headline)
						}
						.padding(.horizontal, 4)
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
			.padding()
			
		}
		.padding()
		.onChange(of: currentPage) {
			if currentPage == 2 {
				continueAnimation()
			}
		}
	}
	
	private func continueAnimation() {
		guard currentStep < 3 else { return }
		
		let delay = stepDelay(for: currentStep)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
			if currentPage == 2 {
				withAnimation(.easeInOut(duration: 1)) {
					currentStep += 1
				}
				continueAnimation()
			}
		}
	}
	
	private func stepDelay(for step: Int) -> Double {
		switch step {
		case 0:  return 0.5
		case 1: return 1.5
		case 2: return 1.5
		default: return 0
		}
	}
}

#Preview {
	ThirdOnboardingView(currentPage: .constant(2))
}
