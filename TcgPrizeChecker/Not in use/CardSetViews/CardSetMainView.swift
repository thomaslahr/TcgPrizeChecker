//
//  CardSetMainView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 26/11/2024.
//

//import SwiftUI
//
//struct CardSetMainView: View {
//	
//	let cardSetNumber: String
//	
//	@State private var viewSelection = 0
//	@StateObject private var cardSetViewModel = CardSetViewModel()
//	@State private var searchText = ""
//	
//	var filteredCards: [Card] {
//		if searchText.isEmpty {
//			return cardSetViewModel.cards
//		} else {
//			return cardSetViewModel.cards.filter { card in
//				card.name.localizedStandardContains(searchText) ||
//				card.localId.localizedStandardContains(searchText) 
//			}
//		}
//	}
//	
//	var body: some View {
//		VStack {
//			Picker(selection: $viewSelection) {
//				Text("List View").tag(0)
//				Text("Grid View").tag(1)
//			} label: {
//				Text("Change view type.")
//			}
//			.pickerStyle(.segmented)
//			if viewSelection == 0 {
//				CardSetListView(cardSetViewModel: cardSetViewModel, filteredCards: filteredCards, cardSetNumber: cardSetNumber)
//			} else {
//				VStack {
//					CardSetGridView(cardSetNumber: cardSetNumber, cardSetViewModel: cardSetViewModel, filteredCards: filteredCards)
//				}
//			}
//		}
//		.navigationTitle(cardSetViewModel.name?.rawValue ?? "")
//		.navigationBarTitleDisplayMode(.inline)
//		.searchable(text: $searchText)
//		.task {
//			if cardSetViewModel.cards.isEmpty {
//				await cardSetViewModel.fetchCardSet(cardSetNumber: cardSetNumber)
//			}
//			print("Data is being fetched")
//		}
//	}
//}
//
//#Preview {
//	CardSetMainView(cardSetNumber: "sv01")
//}
