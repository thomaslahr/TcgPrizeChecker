//
//  OnboardingPageView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 20/04/2025.
//

import SwiftUI

struct OnboardingPageView: View {
	
	let title: String
	let description: String
	
	var body: some View {
		RoundedRectangle(cornerRadius: 25)
			.fill(Color.white)
			.shadow(radius: 5)
			.overlay(
				VStack {
					Text(title)
						.font(.title)
					Text(description)
						.font(.body)
				}
					.padding()
			)
			.padding()
	}
}

#Preview {
	OnboardingPageView(title: "Hello there", description: "Yesh yesh.")
}
