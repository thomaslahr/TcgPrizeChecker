//
//  DeckShuffleAnimationView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 05/05/2025.
//

import SwiftUI

struct DeckShuffleAnimationView: View {
	@Environment(\.colorScheme) var colorScheme
	@State private var progress: CGFloat = 0  // This will animate the stroke's progress
	@State private var opacity: Double = 0  // For fade in/out effect
	@Binding var startAnimation: Bool
	@State private var isVisible = false
	var isAnimationCompleted: () -> Void
	
	var body: some View {
		if startAnimation || isVisible {
			VStack {
				ZStack {
					// Circle with animated stroke
					Circle()
						.trim(from: 0, to: progress)  // Animate the stroke from 0% to 100%
						.stroke(lineWidth: 10)
						.frame(maxWidth: 180)
					
					Image(systemName: "gift.fill")
						.font(.system(size: 100))
					
				}
				.foregroundStyle(GradientColors.primaryAppColor)
				.opacity(opacity)  // Apply the fade effect
				
				Text("Deck is being shuffled")
					.font(.title2)
					.fontWeight(.bold)
					.fontDesign(.rounded)
					.foregroundStyle(GradientColors.primaryAppColor)
					.padding()
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.background(colorScheme == .dark ? .black : .white)
			.opacity(isVisible ? 1 : 0)
			.onAppear {
				isVisible = true
				startAnimationCycle()
			}
		}
	}
	
	func startAnimationCycle() {
		withAnimation(.easeIn(duration: 0.4)) {
			opacity = 1
		}
		withAnimation(.easeInOut(duration: 1)) {
			progress = 1.2
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
			isAnimationCompleted() // Let parent start rendering next views
		}
		
		// Call completion after animation finishes
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
			withAnimation(.easeOut(duration: 0.4)) {
				opacity = 0
			}
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
				isVisible = false
				progress = 0
			}
		}
	}
}

#Preview {
	DeckShuffleAnimationView(startAnimation: .constant(true), isAnimationCompleted: {})
}
