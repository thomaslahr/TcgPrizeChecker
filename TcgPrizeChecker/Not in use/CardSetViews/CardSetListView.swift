//
//  CardSetListView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 27/10/2024.
//

//import SwiftUI
//import SwiftData
//
//struct CardSetListView: View {
//	
//	@ObservedObject var cardSetViewModel: CardSetViewModel
//	@Environment(\.modelContext) private var modelContext
//	//@State private var isSearching = false
//	
//	let filteredCards: [Card]
//	
//	let cardSetNumber: String
//
//	var body: some View {
//		ScrollView {
//			VStack {
//				ForEach(filteredCards, id: \.localId) { card in
//					NavigationLink(value: card) {
//						HStack {
//							Text(card.localId)
//							Text(card.name)
//							Spacer()
//							AsyncImage(url: URL(string: "\(card.image ?? "")/low.webp")) { image in
//								image
//									.resizable()
//									.aspectRatio(contentMode: .fit)
//									.frame(maxWidth: 75)
//							} placeholder: {
//								Image("cardBackMedium")
//									.resizable()
//									.aspectRatio(contentMode: .fit)
//									.frame(maxWidth: 75)
//							}
//							VStack {
//								Button {
//									let imageURL = "\(card.image ?? "")/high.webp"
//									
//									Task {
//										do {
//											let imageData = try await cardSetViewModel.downloadImage(from: imageURL)
//											
//											cardSetViewModel.saveImagetoSwiftData(
//												modelContext: modelContext,
//												imageData: imageData,
//												id: card.id,
//												localId: card.localId,
//												name: card.name,
//												cardToSave: "Deck"
//									
//											)
//										} catch {
//											print("Error downloading image: \(error.localizedDescription)")
//										}
//									}
//								} label: {
//									ZStack {
//										Circle()
//											.frame(maxWidth: 50)
//										Label("Add Card to Deck", systemImage: "plus")
//											.labelStyle(.iconOnly)
//											.foregroundStyle(.white)
//									}
//								}
//								
//								Button {
//									let imageURL = "\(card.image ?? "")/high.webp"
//									Task {
//										do {
//											let imageData = try await cardSetViewModel.downloadImage(from: imageURL)
//											cardSetViewModel
//												.saveImagetoSwiftData(
//													modelContext: modelContext,
//													imageData: imageData,
//													id: card.id,
//													localId: card.localId,
//													name: card.name,
//													cardToSave: "Playable"
//												)
//										} catch {
//											print("Error downloading image: \(error.localizedDescription)")
//										}
//									}
//								} label: {
//									
//									ZStack {
//										Circle()
//											.foregroundStyle(.red)
//											.frame(maxWidth: 50)
//										
//										Label("Add Card to Deck", systemImage: "heart.fill")
//											.labelStyle(.iconOnly)
//											.foregroundStyle(.white)
//										
//										
//									}
//								}
//							}
//							
//						}
//					}
//					Divider()
//				}
//				
//				.navigationDestination(for: Card.self) { card in
//					CardView(cardNumber: card.localId, cardSetNumber: cardSetNumber)
//					
//					
//				}
//				
//			}
//			.padding()
//		}
//		.scrollIndicators(.hidden)
//	}
//}

//Preview trenger ikke bli kommentert tilbake igjen

//#Preview {
//	NavigationStack {
//		CardSetListView(filteredCards: , cardSetNumber: "01")
//	}
//}
