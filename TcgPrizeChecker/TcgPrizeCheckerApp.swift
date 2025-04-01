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
    var body: some Scene {
        WindowGroup {
			MainAppView()
				.modelContainer(for: [PersistentCard.self, PlayableCard.self, Deck.self, PrizeCheckResult.self])
        }
    }
	
	init() {
		print(URL.applicationSupportDirectory.path(percentEncoded: false))
	}
}
