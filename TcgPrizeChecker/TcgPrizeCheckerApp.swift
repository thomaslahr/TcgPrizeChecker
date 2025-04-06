//
//  TcgPrizeCheckerApp.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 27/10/2024.
//

import SwiftUI
import SwiftData

@main
struct TcgPrizeCheckerApp: App {
	
	//Can be removed if not deployed for iOS17 and below
	@StateObject private var deckSelectionViewModel = DeckSelectionViewModel()
	
    var body: some Scene {
        WindowGroup {
			MainAppView()
				.modelContainer(for: [PersistentCard.self, PlayableCard.self, Deck.self, PrizeCheckResult.self])
			//Can be removed if not deployed for iOS17 and below
				.environmentObject(deckSelectionViewModel)
        }
    }
	
	init() {
		print(URL.applicationSupportDirectory.path(percentEncoded: false))
	}
}
