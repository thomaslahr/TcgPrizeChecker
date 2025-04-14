//
//  SimpleButtonView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 14/04/2025.
//

import SwiftUI

struct SimpleButtonView: View {
	let buttonText: String
	let isButtonFilled: Bool
	var body: some View {
		Text(buttonText)
			.foregroundStyle(isButtonFilled ? .white : .primary)
			.padding()
			.frame(maxWidth: 120)
			.background {
				if isButtonFilled {
					RoundedRectangle(cornerRadius: 8)
						.fill(.blue)
				} else {
					RoundedRectangle(cornerRadius: 8)
						.stroke(lineWidth: 2)
				}
			}
			.tint(.primary)
	}
}

#Preview {
	SimpleButtonView(buttonText: "Save result", isButtonFilled: true)
}
