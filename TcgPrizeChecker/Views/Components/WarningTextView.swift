//
//  WarningTextView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 07/04/2025.
//

import SwiftUI

struct WarningTextView: View {
	let text: String
	let changeColor: Bool
	
    var body: some View {
		Text(text)
			.foregroundStyle(changeColor ? .red : .primary)
			.font(.caption)
			.fontWeight(.bold)
    }
}

#Preview {
	WarningTextView(text: "There's too many cards in the deck.", changeColor: false)
}
