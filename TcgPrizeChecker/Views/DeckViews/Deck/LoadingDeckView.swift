//
//  LoadingDeckView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 13/04/2025.
//

import SwiftUI

struct LoadingDeckView: View {
	let selectedDeck: Deck?
	let deckViewModel: DeckViewModel?
	
    var body: some View {
		Group {
			if let deck = selectedDeck,
			   let viewModel = deckViewModel,
			   viewModel.isDeckCached(deck) {
					Color.clear
						.frame(maxWidth: .infinity, maxHeight: .infinity)
				} else {
					ProgressView("Loading deck...")
						.frame(maxWidth: .infinity, maxHeight: .infinity)
				}
		}
		.background(.white.opacity(0.01))
    }
}

//#Preview {
//	LoadingDeckView(selectedDeck: nil, deckViewModel: <#DeckViewModel?#>)
//}
