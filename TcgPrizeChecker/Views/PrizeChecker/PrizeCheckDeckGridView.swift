//
//  PrizeCheckDeckGridView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 09/04/2025.
//

import SwiftUI

import SwiftUI
import SwiftData

struct PrizeCheckDeckGridView: View {
	@Environment(\.modelContext) private var modelContext
	@State private var cardOffset: CGFloat = 0
	@State private var isDragging = false
	@State private var cardOpacity: Double = 1.0
	
	@Query var deck: [PersistentCard]
	@Query var decks: [Deck]
	
	let selectedDeckID: String
	let columns = [GridItem(.adaptive(minimum: 60))]
	
	
	@State private var currentCardIndex: Int?
	@ObservedObject var imageCache: ImageCacheViewModel
	
	var body: some View {
		ZStack {
			ScrollView {
				ZStack {
					LazyVGrid(columns: columns) {
						if let selectedDeck = decks.first(where: {$0.id == selectedDeckID}) {
							ForEach(selectedDeck.cards, id: \.uniqueId) { card in
								if let cachedImage = imageCache.cache[card.uniqueId] {
									Image(uiImage: cachedImage)
										.resizable()
										.aspectRatio(contentMode: .fit)
										.frame(maxWidth: 70)
										.onAppear {
											print("Loading cached images")
										}
									
								}  else if let image = UIImage(data: card.imageData) {
									let targetSize = CGSize(width: 140, height: 200)
									if let downscaled = image.downscaled(to: targetSize) {
										Image(uiImage: downscaled)
											.resizable()
											.aspectRatio(contentMode: .fit)
											.frame(maxWidth: 70)
											.onAppear {
												print("Loading and caching downscaled image")
												imageCache.cache[card.uniqueId] = downscaled
											}
									}
								}
							}
							.shadow(radius: 5)
						}
					}
				}
				.padding()
				
			}
		}
		
	}
}

#Preview {
	PrizeCheckDeckGridView(selectedDeckID: "3318B2A1-9A6E-4B34-884F-E8D52A5811A5", imageCache: ImageCacheViewModel())
}


