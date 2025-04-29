//
//  MainOnboardingView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 20/04/2025.
//

import SwiftUI

struct MainOnboardingView: View {
	@State private var currentPage = 0
	@State private var currentStep = 0
	@Binding var isLaunchingForTheFirstTime: Bool
	private let totalPages = 5
	@State private var hasShownPageDots = false
	
    var body: some View {
		let blurAmount = currentStep > 0 || currentPage != 0 ? 4 : 0.6
		
		ZStack {
			OnboardingBackgroundView()
				.blur(radius: blurAmount)
				.animation(.easeInOut(duration: 0.3), value: currentPage)
				//.animation(.easeInOut(duration: 0.3), value: currentStep)
				.background(.black)
				.clipShape(RoundedRectangle(cornerRadius: 25))
				.shadow(radius: 3)
				.padding()
				.ignoresSafeArea(.keyboard)
			VStack {
				TabView(selection: $currentPage) {
					FirstOnboardingView(currentPage: $currentPage)
						.tag(0)
					SecondOnboardingView(currentPage: $currentPage)
						.padding()
						.tag(1)
					ThirdOnboardingView(currentPage: $currentPage)
						.tag(2)
					FourthOnboardingView(currentPage: $currentPage)
						.tag(3)
					FifthOnboardingView(isLaunchingForTheFirstTime: $isLaunchingForTheFirstTime)
						.tag(4)
				}
				.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
				.overlay(alignment: .bottom) {
							HStack(spacing: 10) {
										   ForEach(0..<totalPages, id: \.self) { index in
											   Circle()
												   .fill(index == currentPage ? Color.blue : Color.gray.opacity(0.4))
												   .frame(width: 10, height: 10)
										   }
									   }
							.opacity(hasShownPageDots ? 1 : 0)
							.animation(.easeInOut(duration: 1), value: hasShownPageDots)
							
									   .padding(.bottom, 40)
				}
				.overlay(alignment: .top) {
					OnboardingTitleView(title: "Quick Tutorial", fontSize: .title3)
						.padding()
						.opacity(currentPage != 0 ? 1 : 0)
						.animation(.easeInOut(duration: 0.3), value: currentPage)
					
					Button("Debug button") {
						isLaunchingForTheFirstTime = false
					}
				}
			}
			.clipShape(RoundedRectangle(cornerRadius: 25))
			.padding()
		}
		.onChange(of: currentPage) {
			if currentPage != 0 || currentStep > 1 {
				hasShownPageDots = true
			}
			
			if currentPage == 0 && currentStep >= 0 {
				continueAnimation()
			}
		}
		.onChange(of: currentStep) {
			if currentStep > 1 || currentPage != 0 {
				hasShownPageDots = true
			}
		}
		.onAppear {
			if currentStep == 0 {
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
			//Triggers the blur on the background
		case 0:  return 0.75
			//Triggers the fade in of the navigation dots at the bottom
		case 1: return 1
//		case 2: return 2.5
		default: return 0
		}
	}
}

#Preview {
	MainOnboardingView(isLaunchingForTheFirstTime: .constant(true))
}
