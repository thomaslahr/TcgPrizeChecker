//
//  SortMenuView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 18/04/2025.
//

import SwiftUI

struct SortMenuView: View {
	
	@ObservedObject var deckViewModel: DeckViewModel
	let paddingSize: CGFloat
	let fontSize: CGFloat
	
    var body: some View {
		Menu {
			ForEach(CardSortOrder.allCases) { sort in
				HStack{
					Button {
						deckViewModel.cardSortOrder = sort
					} label: {
						HStack {
							Text(sort.rawValue)
							if sort == deckViewModel.cardSortOrder {
								Spacer()
								Image(systemName: "checkmark")
							}
						}
					}
				}
			}
		} label: {
				Image(systemName: "arrow.up.arrow.down")
				.font(.system(size: fontSize))
				.accessibilityLabel("Sort Cards")
				.foregroundStyle(.white)
				.padding(paddingSize)
					.background {
						RoundedRectangle(cornerRadius: 8)
							.fill(GradientColors.primaryAppColor)
					}
		}
    }
}

#Preview {
	SortMenuView(deckViewModel: DeckViewModel(imageCache: ImageCacheViewModel()), paddingSize: 8, fontSize: 10)
}
