//
//  ViewDescriptionTextView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 18/04/2025.
//

import SwiftUI

struct ViewDescriptionTextView: View {
		let text: String
		
		var body: some View {
			Text(text)
				.font(.callout)
				.fontWeight(.bold)
		}
}

#Preview {
	ViewDescriptionTextView(text: "Tap on an energy card to add it to a deck.")
}
