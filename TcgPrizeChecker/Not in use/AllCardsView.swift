//
//  AllCardsView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 26/11/2024.
//
//
//import SwiftUI
//import SwiftData
//
//struct AllCardsView: View {
//	
//	@ObservedObject var allCardsViewModel = CardSetViewModel()
//	@Environment(\.modelContext) private var modelContext
//	@State private var searchText = ""
//	@State private var showImage = false
//	
//	//Dette burde gjøres i funksjonen som kaller på API-en. Det er en unødvendig tung fetch å hente 18 000 kort, for så å filtrere de. Men dette er en start.
//	var filteredCards: [Card] {
//		if searchText.isEmpty {
//			return allCardsViewModel.cards.filter { card in
//				if card.id.contains("swsh") {
//					if let number = extractSetNumber(from: card.id), number >= 9, number <= 12.5 {
//						return true
//					}
//				}
//				return card.id.contains("sv")
//				
//			}
//		} else {
//			return allCardsViewModel.cards.filter { card in
//				card.name.localizedStandardContains(searchText) &&
//				(card.id.contains("sv") || card.id.contains("swsh"))
//			}
//		}
//	}
//	
//	var body: some View {
//		NavigationStack {
//			Text("\(filteredCards.count)")
//			if !searchText.isEmpty {
//				Toggle(isOn: $showImage) {
//					Text("Show Image")
//				}
//				
//				List {
//					Text("\(filteredCards.count)")
//					ForEach(filteredCards, id: \.id) { card in
//						HStack {
//							Text(card.id)
//							Text(card.name)
//							Spacer()
//							if showImage {
//								AsyncImage(url: URL(string: "\(card.image ?? "")/low.webp")) { image in
//									image
//										.resizable()
//										.aspectRatio(contentMode: .fit)
//										.frame(maxWidth: 60)
//										.shadow(color: .black, radius: 3)
//								} placeholder: {
//									Image("cardBackMedium")
//										.resizable()
//										.aspectRatio(contentMode: .fit)
//										.frame(maxWidth: 60)
//								}
//							}
//							Button {
//								let imageURL = "\(card.image ?? "")/high.webp"
//								
////								allCardsViewModel.downloadImage(from: imageURL) { result in
////									switch result {
////									case .success(let imageData):
////										allCardsViewModel.saveImagetoSwiftData(imageData: imageData, id: UUID().uuidString, localId: card.localId, name: card.name, modelContext: modelContext)
////									case .failure(let error):
////										print("Error downloading image: \(error)")
////									}
////								}
//								Task {
//									try await allCardsViewModel.downloadImage(from: imageURL)
//								}
//							} label: {
//								ZStack {
//									Circle()
//										.foregroundStyle(.blue)
//										.frame(maxWidth: 40)
//									Label("Add Card to Deck", systemImage: "plus")
//										.labelStyle(.iconOnly)
//										.foregroundStyle(.white)
//								}
//							}
//						}
//					}
//				}
//				.task {
//					print("API call was made for all cards.")
//					await allCardsViewModel.fetchAllCards()
//				}
//				
//			} else {
//				//DeckGridView()
//			}
//		}
//		.searchable(text: $searchText, prompt: "Search for cards to add to deck")
//		.onChange(of: searchText) { oldValue, newValue in
//			if searchText.isEmpty {
//				showImage = false
//			}
//		}
//	}
//	
//	func extractSetNumber(from id: String) -> Double? {
//		let prefix = "swsh"
//		
//		if id.starts(with: prefix) {
//			let numberString = id.dropFirst(prefix.count)
//			return Double(numberString)
//		}
//		return nil
//	}
//}
//
////#Preview {
////	AllCardsView()
////}
