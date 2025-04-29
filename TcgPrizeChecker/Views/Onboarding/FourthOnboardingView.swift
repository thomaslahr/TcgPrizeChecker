//
//  FourthOnboardingView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 23/04/2025.
//

import SwiftUI

struct FourthOnboardingView: View {
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
					OnboardingTitleView(title: "Prize Checking", fontSize: .title)
						.padding()
					
					if currentStep >= 1 {
						HStack {
							Image(systemName: "gift.circle.fill").foregroundStyle(GradientColors.primaryAppColor)
								.font(.largeTitle)
							OnboardingLongerTextView(textBody: "After building a deck it's time to practice prize checking.", fontSize: .headline)
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
						VStack {
							ZStack {
								RoundedRectangle(cornerRadius: 8)
									.fill(.black.opacity(0.7))
								RoundedRectangle(cornerRadius: 8)
									.stroke(GradientColors.primaryAppColor, lineWidth: 3)
							}
							.shadow(radius: 5)
							.frame(maxHeight: 40)
							
							OnboardingLongerTextView(textBody: "Simply type into the textfields and guess the prize cards.", fontSize: .headline)
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
								Circle()
									.foregroundStyle(GradientColors.primaryAppColor)
									.frame(width: 35, height: 35)
								Image(systemName: "list.clipboard")
									.font(.title3)
									.fontWeight(.semibold)
									.fontDesign(.rounded)
							}
							OnboardingLongerTextView(textBody: "Your prize checking history can be saved, so you can keep track of your improving skill.", fontSize: .headline)
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
			if currentPage == 3 {
				continueAnimation()
			}
		}
	}
	
	private func continueAnimation() {
		guard currentStep < 3 else { return }
		
		let delay = stepDelay(for: currentStep)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
			if currentPage == 3 {
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
	FourthOnboardingView(currentPage: .constant(0))
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(.black)
}
