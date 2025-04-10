//
//  DividerView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 09/04/2025.
//

import SwiftUI

struct DividerView: View {
	let height: CGFloat
	let color: Color
    var body: some View {
		RoundedRectangle(cornerRadius: 12)
			.foregroundStyle(color)
			.frame(maxWidth: 150)
			.frame(height: height)
			.padding(.horizontal, 20)
			.padding(.bottom, 10)
    }
}

#Preview {
	DividerView(height: 3, color: .itemBlue)
}
