//
//  FirstOnboardingView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 20/04/2025.
//

import SwiftUI

struct FirstOnboardingView: View {

	@State private var currentStep = 0
	@Binding var currentPage: Int
	
	var body: some View {
		VStack {
			if currentStep >= 1 {
				VStack(spacing: 3) {
					Text("Welcome to the")
						.fontWeight(.bold)
						.font(.headline)
					OnboardingTitleView(title: "TCG Prize Checker", fontSize: .title)
					Text("app")
						.font(.headline)
						.fontWeight(.bold)
				}
				.opacity(currentStep > 0 ? 1 : 0)
				.animation(.easeInOut(duration: 0.6), value: currentPage)
				.foregroundStyle(.white)
				.fontDesign(.rounded)
			}
	
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.overlay {
			if currentStep >= 2 {
				VStack(alignment: .leading) {
					OnboardingLongerTextView(textBody: "The best way to practice prize checking when you don't have the physical cards with you.", fontSize: .headline)
						.transition(
							.asymmetric(
								insertion: AnyTransition.opacity
									.combined(with: .offset(y: 25)),
								removal: .opacity)
						)
				}
				.padding()
				.offset(y: 150)
				.fontWeight(.semibold)
				.foregroundStyle(.white)
				.padding(10)
				.multilineTextAlignment(.leading)
				.font(.system(size: 15))
				.transition(
					   .asymmetric(
						   insertion: AnyTransition.opacity
							   .combined(with: .offset(y: 25)),
						   removal: .opacity)
				   )
			}
		}
		.onChange(of: currentPage) {
			if currentPage == 0 {
				continueAnimation()
			}
		}
		
		.onAppear {
			if currentStep == 0 {
				print("Current page is 0")
				continueAnimation()
			}
		}
	}
	
	private func continueAnimation() {
		guard currentStep < 3 else { return }
		
		let delay = stepDelay(for: currentStep)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
			if currentPage == 0 {
				withAnimation(.easeInOut(duration: 0.5)) {
					currentStep += 1
				}
				continueAnimation()
			}
		}
	}
	
	private func stepDelay(for step: Int) -> Double {
		switch step {
		case 0:  return 0.75
		case 1: return 1
		case 2: return 2.5
		default: return 0
		}
	}
}

#Preview {
	FirstOnboardingView(currentPage: .constant(0))
		.background(.red)
}
