//
//  SortMenuView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 18/04/2025.
//

import SwiftUI

struct SortMenuView<SortType>: View where
SortType: CaseIterable & RawRepresentable & Equatable & Identifiable,
SortType.RawValue == String
{

	@Binding var sortOrder: SortType
	let paddingSize: CGFloat
	let fontSize: CGFloat
	let menuImageName: String
	
	@State private var sortHapticFeedback = false
	
	var body: some View {
		Menu {
			ForEach(Array(SortType.allCases)) { sort in
				HStack{
					Button {
						sortOrder = sort
					} label: {
						HStack {
							Text(sort.rawValue)
							if sort == sortOrder {
								Spacer()
								Image(systemName: "checkmark")
							}
						}
					}
				}
			}
		} label: {
				Image(systemName: menuImageName)
				.font(.system(size: fontSize))
				.accessibilityLabel("Sort Cards")
				.foregroundStyle(.white)
				.padding(paddingSize)
					.background {
						RoundedRectangle(cornerRadius: 8)
							.fill(GradientColors.primaryAppColor)
					}
		}
		.onChange(of: sortOrder) {
			sortHapticFeedback.toggle()
		}
		.addCardHapticFeedback(trigger: sortHapticFeedback)
	}
}

//struct SortMenuView: View {
//	
//	@ObservedObject var deckViewModel: DeckViewModel
//	let paddingSize: CGFloat
//	let fontSize: CGFloat
//	
//    var body: some View {
//		Menu {
//			ForEach(CardSortOrder.allCases) { sort in
//				HStack{
//					Button {
//						deckViewModel.cardSortOrder = sort
//					} label: {
//						HStack {
//							Text(sort.rawValue)
//							if sort == deckViewModel.cardSortOrder {
//								Spacer()
//								Image(systemName: "checkmark")
//							}
//						}
//					}
//				}
//			}
//		} label: {
//				Image(systemName: "arrow.up.arrow.down")
//				.font(.system(size: fontSize))
//				.accessibilityLabel("Sort Cards")
//				.foregroundStyle(.white)
//				.padding(paddingSize)
//					.background {
//						RoundedRectangle(cornerRadius: 8)
//							.fill(GradientColors.primaryAppColor)
//					}
//		}
//    }
//}

//#Preview {
//	SortMenuView<SortType: CaseIterable & Equatable & Identifiable & RawRepresentable, ViewModel>(
//		
//		paddingSize: 8,
//		fontSize: 10,
//		menuImageName: "arrow.up.arrow.down"
//	)
//}
