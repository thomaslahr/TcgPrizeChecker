//
//  SearchbarView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 07/04/2025.
//

import SwiftUI

struct SearchbarView: View {
	@Binding var searchText: String
	@Binding var isInputActive: Bool
	let debounceTimer: Timer?
	
	@FocusState private var isFocused: Bool
	var body: some View {
		HStack {
			Image(systemName: "magnifyingglass")
				.padding(.leading, 5)
			TextField(text: $searchText) {
				Text("Search for cards to add")
					.foregroundStyle(.gray)
			}
			.focused($isFocused)
			.onChange(of: isFocused) {
				isInputActive = isFocused
			}
			.autocorrectionDisabled(true)
			.padding(.leading, 7)
			.padding(.vertical, 8)
			.background {
				RoundedRectangle(cornerRadius: 8).fill(.gray.opacity(0.2))
					.background {
						RoundedRectangle(cornerRadius: 8)
							.stroke(lineWidth: 1)
							.foregroundStyle(isFocused ? .blue : .clear)
							.animation(.easeIn(duration: 0.1), value: isFocused)
					}
				
			}
			//handleSearch(newValue)
			
			.overlay(alignment: .trailing) {
				if !searchText.isEmpty {
					Button {
						searchText = ""
					} label: {
						Image(systemName: "x.circle.fill")
							.foregroundStyle(.gray)
						
					}
					.padding(.trailing, 10)
				}
			}
		}
		.padding(.horizontal, 15)
	}
}

#Preview {
	SearchbarView(
		searchText: .constant(""), isInputActive: .constant(false),
		debounceTimer: nil
	)
}
