//
//  PrizeSettingsView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 18/12/2024.
//

import SwiftUI

struct PrizeSettingsView: View {
	@Binding var hideTimer: Bool
	@Binding var isRightCardOnTop: Bool
	
    var body: some View {
		VStack {
			ZStack {
				Text("Prize Checker Settings")
					.frame(maxHeight: .infinity, alignment: .top)
					.padding()
					.font(.title3)
					.fontWeight(.bold)
				VStack {
					Toggle("Hide Timer", isOn: $hideTimer)
						.padding()
						.font(.headline)
					Toggle("Card to the right on top?", isOn: $isRightCardOnTop)
						.padding()
						.font(.headline)
				}
			}
		}
		
    }
}

#Preview {
	PrizeSettingsView(hideTimer: .constant(false), isRightCardOnTop: .constant(false))
		.frame(maxHeight: 400)
		.border(.red)
}
