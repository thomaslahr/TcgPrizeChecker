//
//  MatchedCardsView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 09/05/2025.
//

import SwiftUI
import SwiftData

struct MatchedCardsView: View {
	@Environment(\.modelContext) private var modelContext
	@Environment(\.dismiss) private var dismiss
	@State private var userInput = ""
	@ObservedObject var importDeckViewModel: ImportDeckViewModel
	@FocusState private var isTextFieldFocused: Bool
	@Binding var activeModel: DeckModal?
	let parsedCards: [ParsedCardLine]
	
	@State private var showMessage = false
	
	var body: some View {
		
		let numberOfLetters = userInput.count
		Group {
			if importDeckViewModel.isLoading {
				CustomProgressView(importDeckViewModel: importDeckViewModel)
				
			} else {
				VStack {
					Text("Deck List")
						.font(.title)
						.fontWeight(.bold)
						.fontDesign(.rounded)
						.foregroundStyle(GradientColors.primaryAppColor)
					
					VStack {
						HStack(spacing: 5) {
							TextField(text: $userInput) {
								Text("Enter a name for the deck")
								
							}
							.focused($isTextFieldFocused)
							.autocorrectionDisabled(true)
							.padding(.leading, 8)
							.frame(height: 50)
							.background {
								RoundedRectangle(cornerRadius: 12)
									.stroke(lineWidth: 2)
									.foregroundStyle(GradientColors.primaryAppColor)
							}
							.overlay(alignment: .trailing) {
								if numberOfLetters > 0 {
									Text("\(numberOfLetters)/15")
										.fontWeight(numberOfLetters > 15 ? .bold : .regular)
										.foregroundStyle(numberOfLetters > 15 ? .red : .primary.opacity(0.3))
										.padding()
								}
							}
							Button {
								if importDeckViewModel.totalFetchedCardCount <= 60 {
									Task {
										do {
											let persistentCards = try await importDeckViewModel.createPersistentCards(from: importDeckViewModel.matchedCards)
											let newDeck = Deck(name: userInput, cards: persistentCards)
											modelContext.insert(newDeck)
											try modelContext.save()
											activeModel = .none
										} catch {
											print("Failed to save deck: \(error)")
										}
										
									}
								} else {
									showMessage = true
									
									Task {
										try await Task.sleep(nanoseconds: 2_000_000_000)
										withAnimation(.easeInOut(duration: 0.3)) {
											showMessage = false
										}
									}
								}
							} label: {
								Text("Create Deck")
									.font(.system(size: 15))
									.fontWeight(.semibold)
								
									.frame(width: 100, height: 50)
									.foregroundStyle(.white)
									.background {
										if userInput.isEmpty || numberOfLetters > 15 || importDeckViewModel.totalCardsToFetch > 60 {
											RoundedRectangle(cornerRadius: 12)
												.foregroundStyle(.gray)
										} else {
											RoundedRectangle(cornerRadius: 12)
												.foregroundStyle(GradientColors.primaryAppColor)
										}
									}
							}
							
							.disabled(importDeckViewModel.matchedCards.isEmpty || userInput.isEmpty || numberOfLetters > 15 || importDeckViewModel.totalCardsToFetch > 60)
						}
						
						.padding(.horizontal)
						if numberOfLetters > 15 && importDeckViewModel.totalFetchedCardCount > 60 {
							WarningTextView(text: "There's too many cards in the deck and the deck name is too long..", changeColor: true)
								.padding(.vertical, 5)
						}
						else if numberOfLetters > 15 {
							WarningTextView(text: "Deck name is too long..", changeColor: true)
								.padding(.vertical, 5)
						} else {
							Text(importDeckViewModel.totalFetchedCardCount > 60 ?  "There's too many cards in the deck." : "There are \(importDeckViewModel.totalFetchedCardCount) cards in the deck.")
								.font(.caption)
								.fontWeight(.bold)
								.foregroundStyle(importDeckViewModel.totalFetchedCardCount > 60 ? .red : .primary)
								.padding(.vertical, 5)
						}
						
					}
					
					ScrollView {
						LazyVStack {
							ForEach(importDeckViewModel.matchedCards.indices, id: \.self) { index in
								
								let matched = importDeckViewModel.matchedCards[index]
								
								HStack {
									Text("\(matched.quantity)x")
										.font(matched.quantity > 19 ? .subheadline : .headline)
										.frame(width: 30)
										.frame(maxHeight: .infinity, alignment: .center)
									
									// Load image from URL
									
									if matched.card.category == "Energy" && matched.card.localId == "" {
										if let energyType = EnergyType.allCases.first(where: { $0.name == matched.card.name }) {
											// Try to fetch the UIImage from the energy type
											if let uiImage = energyType.energyCardUIImage {
												Image(uiImage: uiImage)
													.resizable()
													.aspectRatio(contentMode: .fit)
													.frame(width: 50, height: 70)
													.background(Color.gray.opacity(0.2)) // Optional background color
											} else {
												// Fallback in case no UIImage is available (for Colorless and Dragon)
												Text("No image available")
													.foregroundColor(.gray)
													.frame(width: 50, height: 70)
											}
										} else {
											// Handle unrecognized energy type
											Text("Unknown Energy")
												.foregroundColor(.red)
												.frame(width: 50, height: 70)
										}
									} else {
										if let urlString = matched.card.image {
											CachedImageView(urlString: "\(urlString)/low.webp")
												.frame(width: 50, height: 70)
										}
									}
									
									VStack(alignment: .leading) {
										Text("\(matched.card.name)")
											.font(.headline)
										VStack(alignment: .leading) {
											Text("\(matched.card.category ?? "")")
											
											HStack {
												if let cardSetName = CardSetName.fromCardSetID(matched.card.id) {
													Text("(\(cardSetName.rawValue))")
												}
												Text("#\(matched.card.localId)")
												Spacer()
											}
										}
										.font(.system(size: 10))
										.foregroundColor(.secondary)
									}
									.frame(maxWidth: .infinity, maxHeight: .infinity)
									.padding(.leading, 8)
									
									HStack {
										let disabledButton = matched.quantity >= 4 &&  (matched.card.category != "Energy" && matched.card.localId != "")
										
										Button {
											importDeckViewModel.matchedCards[index].quantity -= 1
										} label: {
											Image(systemName: "minus.circle")
												.foregroundStyle(matched.quantity <= 0 ? .gray : .red)
										}
										.font(.system(size: 25))
										.disabled(matched.quantity <= 0)
										
										Button {
											importDeckViewModel.matchedCards[index].quantity += 1
										} label: {
											Image(systemName: "plus.circle")
												.foregroundStyle(disabledButton ? .gray : .green)
										}
										.font(.system(size: 25))
										.disabled(disabledButton)
									}
									.padding(8)
									.background {
										RoundedRectangle(cornerRadius: 20)
											.foregroundStyle(.black.opacity(0.7))
									}
								}
								.padding(.top, 3)
								.padding(.horizontal)
								
								if index < importDeckViewModel.matchedCards.count - 1 {
									Divider()
										.padding(.horizontal)
								}
							}
							.onTapGesture {
								withAnimation {
									isTextFieldFocused = false
								}
							}
						}
						.background(.black.opacity(0.00001))
						.onTapGesture {
							withAnimation {
								isTextFieldFocused = false
							}
						}
						
					}
				}
				.overlay {
					MessageView(messageContent: "There's too many cards in the deck.")
						.opacity(showMessage ? 1 : 0)
				}
				//	.frame(maxWidth: .infinity, maxHeight: .infinity)
			}
		}
		.interactiveDismissDisabled()
		.onAppear {
			Task {
				await importDeckViewModel.matchAndFetchDetailedCards(from: parsedCards)
			}
		}
	}
	private func removeCard(at offsets: IndexSet) {
		importDeckViewModel.matchedCards.remove(atOffsets: offsets)
	}
}

#Preview {
	let mockViewModel = ImportDeckViewModel()
	mockViewModel.matchedCards = [.sample, .sample]
	return MatchedCardsView(importDeckViewModel: mockViewModel, activeModel: .constant(.importDeck), parsedCards: [.sample])
}
