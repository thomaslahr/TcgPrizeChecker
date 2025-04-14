//
//  MainAppView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 08/11/2024.
//

import SwiftUI
import SwiftData


//struct MainAppView: View {
//	@StateObject private var deckSelectionViewModel = DeckSelectionViewModel()
//	
//    var body: some View {
//		TabView {
//			
//			Tab("Deck", systemImage: "rectangle.on.rectangle.square.fill") {
//				MainDeckView()
//					.environmentObject(deckSelectionViewModel)
//			}
//			
//			Tab("Prize Checker", systemImage: "gift.circle") {
//				PrizeCheckView()
//					.environmentObject(deckSelectionViewModel)
//			}
//
////			Tab("Cards", systemImage: "plus") {
////				CardSeriesView()
////			}
//			
//		}
//    }
//}

struct MainAppView: View {
	//Can be removed if not deployed for iOS17 and below
	
	@StateObject private var imageCache = ImageCacheViewModel()
	@StateObject var deckViewModel: DeckViewModel
	
	init() {
			let cache = ImageCacheViewModel()
			_imageCache = StateObject(wrappedValue: cache)
			_deckViewModel = StateObject(wrappedValue: DeckViewModel(imageCache: cache))
		}
	var body: some View {
		TabView {
			MainDeckView(imageCache: imageCache, deckViewModel: deckViewModel)
			//Can be removed if not deployed for iOS17 and below
				//.environmentObject(deckSelectionViewModel)
				.tabItem {
					Label("Deck", systemImage: "rectangle.on.rectangle.square.fill")
				}

			PrizeCheckView(imageCache: imageCache)
			//	.environmentObject(deckSelectionViewModel)
				.tabItem {
					Label("Prize Checker", systemImage: "gift.circle")
				}

//            CardSeriesView()
//                .tabItem {
//                    Label("Cards", systemImage: "plus")
//                }
		}
	}
}

#Preview {
    MainAppView()
}
