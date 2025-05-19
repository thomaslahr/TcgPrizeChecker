//
//  CustomProgressView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 12/05/2025.
//

import SwiftUI

struct CustomProgressView: View {
	@ObservedObject var importDeckViewModel: ImportDeckViewModel

	var body: some View {
		VStack(spacing: 20) {
			ZStack(alignment: .leading) {
				RoundedRectangle(cornerRadius: 10)
					.frame(height: 10)
					.foregroundColor(Color(.systemGray5))
				
				GeometryReader { geometry in
					RoundedRectangle(cornerRadius: 10)
						.fill(GradientColors.primaryAppColor)
						.frame(width: geometry.size.width * progressFraction, height: 10)
						.animation(.easeInOut(duration: 0.2), value: progressFraction)
				}
			}
			.frame(height: 10)
			
			.padding(.horizontal)

			Text("Fetching card \(importDeckViewModel.currentFetchIndex) of \(importDeckViewModel.totalCardsToFetch)")
				.font(.headline)
				.foregroundColor(.secondary)
		}
	}

	private var progressFraction: CGFloat {
		guard importDeckViewModel.totalCardsToFetch > 0 else { return 0 }
		return CGFloat(importDeckViewModel.currentFetchIndex) / CGFloat(importDeckViewModel.totalCardsToFetch)
	}
}

#Preview {
	CustomProgressView(importDeckViewModel: ImportDeckViewModel())
}
