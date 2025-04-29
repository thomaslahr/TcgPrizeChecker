//
//  OnboardingLongerTextView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 21/04/2025.
//

import SwiftUI

struct OnboardingLongerTextView: View {
	let textBody: String
	let fontSize: Font
    var body: some View {
		Text(textBody)
			.font(fontSize)
			.fontDesign(.rounded)
			.fontWeight(.medium)
			.foregroundStyle(.white)
			.fixedSize(horizontal: false, vertical: true)
			.multilineTextAlignment(.leading)
    }
}

#Preview {
	OnboardingLongerTextView(textBody: "The search field is used to search for cards on the internet. Just type in the name of the card you're looking for.", fontSize: .headline)
		.background(.black)
}
