//
//  DeleteAnimationView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 29/04/2025.
//

import SwiftUI

struct DeleteAnimationView: View {
	@State private var progress: CGFloat = 0  // This will animate the stroke's progress
	@State private var opacity: Double = 0  // For fade in/out effect
	
	var body: some View {
		ZStack {
			// Circle with animated stroke
			Circle()
				.trim(from: 0, to: progress)  // Animate the stroke from 0% to 100%
				.stroke(
					Color.red,  // Use a solid red color
					lineWidth: 10
				)
				.frame(maxWidth: 180)
				.onAppear {
					// Fade in the view
					withAnimation(.easeIn(duration: 0.4)) {
						opacity = 1
					}
					
					// Animate the stroke to go from 0 to 1
					withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: false)) {
						progress = 1.5  // Gradually fill the circle
					}
				}
//				.onDisappear {
//					// Fade out the view
//					withAnimation(.easeOut(duration: 1)) {
//						opacity = 0
//					}
//				}

			// Trash icon in the center
			Image(systemName: "trash")
				.font(.system(size: 100))
				.foregroundStyle(.red)
		}
		.opacity(opacity)  // Apply the fade effect
	}
}

#Preview {
    DeleteAnimationView()
}
