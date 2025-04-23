//
//  TcgCardVIew.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 21/04/2025.
//

import SwiftUI

struct TcgCardVIew: View {
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 12)
				.foregroundStyle(.black)
				.frame(maxWidth: 135, maxHeight: 180)
			
			RoundedRectangle(cornerRadius: 12)
				.stroke(lineWidth: 3)
				.frame(maxWidth: 135, maxHeight: 180)
			Text("TCG")
				.font(.system(size: 45))
				.fontWeight(.semibold)
				.fontDesign(.rounded)
				.rotationEffect(Angle(degrees: 60))
		}
		.foregroundStyle(GradientColors.primaryAppColor)
	}
}

#Preview {
	TcgCardVIew()
}
