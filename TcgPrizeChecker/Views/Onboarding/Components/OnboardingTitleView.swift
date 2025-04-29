//
//  OnboardingTitleView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 21/04/2025.
//

import SwiftUI

struct OnboardingTitleView: View {
	let title: String
	let fontSize: Font
    var body: some View {
		Text(title)
			.font(fontSize)
			.fontWeight(.bold)
			.fontDesign(.rounded)
			.foregroundStyle(.white)
			.multilineTextAlignment(.center)
    }
}

#Preview {
	OnboardingTitleView(title: "Searching for cards", fontSize: .title)
		.background(.black)
}
