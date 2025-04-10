//
//  GeometryTester.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 10/04/2025.
//

import SwiftUI

struct GeometryTester: View {
	@State private var isButtonPressed = false
	var body: some View {
		GeometryReader { geo in
			Button {
				isButtonPressed.toggle()
			} label: {
				ZStack {
					Circle()
						.scaleEffect(isButtonPressed ? 1 : 0.5)
					Text("Press")
						.foregroundStyle(.white)
				}
			}
			.offset(
				x: isButtonPressed ? (geo.size.width / 4) - (geo.size.width / 4) : 0, // Center horizontally
				y: isButtonPressed ? (geo.size.height / 4) - (geo.size.height / 4) : 0 // Center vertically
			)
			.frame(maxWidth: .infinity, maxHeight: .infinity)
		
		}
	}
}

#Preview {
	GeometryTester()
}
