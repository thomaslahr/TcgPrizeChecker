//
//  MainAppView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 08/11/2024.
//

import SwiftUI
import SwiftData

struct MainAppView: View {
	@StateObject private var deckSelectionViewModel = DeckSelectionViewModel()
	
    var body: some View {
		TabView {
			
			Tab("Deck", systemImage: "rectangle.on.rectangle.square.fill") {
				MainDeckView()
					.environmentObject(deckSelectionViewModel)
			}
			
			Tab("Prize Checker", systemImage: "gift.circle") {
				PrizeCheckView()
					.environmentObject(deckSelectionViewModel)
			}

//			Tab("Cards", systemImage: "plus") {
//				CardSeriesView()
//			}
			
		}
    }
}

#Preview {
    MainAppView()
}
