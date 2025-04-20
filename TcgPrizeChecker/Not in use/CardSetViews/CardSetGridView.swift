//
//  CardSetGridView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 26/11/2024.
//

//import SwiftUI
//import SwiftData
//
//struct CardSetGridView: View {
//	let cardSetNumber: String
//	
//	@ObservedObject var cardSetViewModel: CardSetViewModel
//	@Environment(\.modelContext) private var modelContext
//	let columns = [GridItem(.adaptive(minimum: 65))]
//	let filteredCards: [Card]
//	
//	@State private var isLongPress = false
//	@State private var selectedCard: Card?
//	
//	var body: some View {
//		ScrollView {
//			LazyVGrid(columns: columns) {
//				ForEach(filteredCards, id: \.localId) { card in
//					Button {
//						guard !isLongPress else { return }
//						let imageURL = "\(card.image ?? "")/high.webp"
//						
//						if !isLongPress {
//							Task {
//								do {
//									let imageData = try await cardSetViewModel.downloadImage(from: imageURL)
//									cardSetViewModel.saveImagetoSwiftData(
//										modelContext: modelContext,
//										imageData: imageData,
//										id: card.id,
//										localId: card.localId,
//										name: card.name,
//										cardToSave: "Deck"
//									)
//								} catch {
//									print("Error downloading image: \(error.localizedDescription)")
//								}
//								
//							}
//						}
//					} label: {
//						AsyncImage(url: URL(string: "\(card.image ?? "")/low.webp")) { image in
//							image
//								.resizable()
//								.aspectRatio(contentMode: .fit)
//								.frame(maxWidth: 75)
//						} placeholder: {
//							Image("cardBackMedium")
//								.resizable()
//								.aspectRatio(contentMode: .fit)
//								.frame(maxWidth: 75)
//						}
//					}
//					.simultaneousGesture(
//						LongPressGesture(minimumDuration: 0.35)
//							.onEnded { _ in
//								isLongPress = true
//								selectedCard = card
//								print("This was a long press")
//							})
//				}
//			}
//			.padding()
//		}
//		.sheet(item: $selectedCard) { card in
//			CardView(cardNumber: card.localId, cardSetNumber: cardSetNumber)
//				.padding()
//				.onDisappear {
//					isLongPress = false
//				}
//		}
//	}
//}


//Preview trenger ikke bli kommentert tilbake igjen.

//#Preview {
//	CardSetGridView(cardSetNumber: "sv01")
//}
