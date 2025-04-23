//
//  OnboardingSettingsView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 21/04/2025.
//

import SwiftUI

struct OnboardingSettingsView: View {
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
								.font(.system(size: 30))
							Text("Decks can be created.")
								.font(.system(size: 16))
								.fontDesign(.rounded)
								.foregroundStyle(.white)
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
								.font(.system(size: 30))
								
							Text("And deleted.")
								.font(.system(size: 16))
								.fontDesign(.rounded)
								.foregroundStyle(.white)
						}
						.transition(
							   .asymmetric(
								   insertion: AnyTransition.opacity
									   .combined(with: .offset(y: 25)),
								   removal: .opacity)
						   )
						.frame(maxWidth: .infinity, alignment: .leading)
					}
					
					if currentStep >= 3 {
						HStack {
							ZStack {
								RoundedRectangle(cornerRadius: 12)
								.foregroundStyle(GradientColors.primaryAppColor)
									.frame(width: 40, height: 40)
								Image(systemName: "tray.2").foregroundStyle(.white)
									.background {
									}
							}
							Text("Energy cards and your added Playables are found here")
								.font(.system(size: 14))
								.fontDesign(.rounded)
								.foregroundStyle(.white)
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
		case 0:  return 1.5
		case 1: return 2
		case 2: return 2.5
		default: return 0
		}
	}
}

#Preview {
	OnboardingSettingsView(currentPage: .constant(5))
}
