//
//  DeckActionsView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 07/04/2025.
//

import SwiftUI
import SwiftData

struct DeckActionsView: View {
	@Environment(\.modelContext) private var modelContext
	var decks: [Deck]
	@Binding var selectedDeck: Deck?
	@Binding var isShowingMessage: Bool
	@Binding var deleteDeck: Bool
	@Binding var activeModal: DeckModal?
	@State private var waveBounce = false
	
	@State private var deleteDeckHapticFeedback = false
	@State private var isDeckBeingDeleted = false
	@Binding var showProgressView: Bool
	
	var body: some View {
		VStack {
			HStack {
				Button {
					if decks.count > 9 {
						showMessage()
					} else {
						activeModal = .create
					}
				} label: {
					Image(systemName: "plus.circle")
						.foregroundStyle(.green)
						.font(.system(size: 30))
				}
				.padding(.leading, 15)
				
				Button {
					if decks.count > 9 {
						showMessage()
					} else {
						activeModal = .importDeck
					}
				} label: {
					Image(systemName: "square.and.arrow.down")
						.foregroundStyle(GradientColors.primaryAppColor)
						.font(.system(size: 25))
				}
				Spacer()
				
				if decks.count > 0 {
					withAnimation {
						Button {
							deleteDeck.toggle()
						} label: {
							Image(systemName: "trash.circle")
								.font(.title)
								.foregroundStyle(.red)
						}
						.addCardHapticFeedback(trigger: deleteDeckHapticFeedback)
						.alert("Are you sure you want to delete the deck?", isPresented: $deleteDeck) {
							Button("Cancel", role: .cancel) { }
							Button("Yes", role: .destructive) {
								deleteDeckHapticFeedback.toggle()
								
								if let deckToRemove = selectedDeck {
									// Step 1: Immediately show progress view while deleting
									showProgressView = true
									
									// Step 2: Delete deck immediately
									modelContext.delete(deckToRemove)
									
									// Step 3: Save the context asynchronously
									Task {
										do {
											try modelContext.save()
											
											// Step 4: Update the UI to reflect the deletion
											// After saving, update UI elements (like resetting the selectedDeck and deck list)
											selectedDeck = nil
											
											// Step 5: Optionally hide progress view after a short delay
											DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
												showProgressView = false
											}
										} catch {
											print("Failed to save context: \(error)")
											showProgressView = false
										}
									}
								}
							}
						}
					}
				}
			}
			.frame(maxWidth: .infinity, alignment: .trailing)
			.padding(.trailing, 15)
		}
		.overlay {
			if !decks.isEmpty {
				HStack(spacing: 2){
					Text("Current deck: ")
						.fontDesign(.rounded)
						.fontWeight(.semibold)
					CustomPickerMenuView(decks: decks)
				}
				//.frame(maxWidth: .infinity, alignment: .center)
			} else {
				HStack {
					Image(systemName: "arrow.left")
					Text("Create a deck to get started.")
						.fontDesign(.rounded)
						.fontWeight(.semibold)
				}
				.offset(x: waveBounce ? -15 : 0)
				.animation(.easeInOut(duration: 0.5), value: waveBounce)
				.frame(maxWidth: .infinity, alignment: .center)
				.onAppear {
					startWaveAnimationLoop()
				}
			}
		}
	}
	private func showMessage() {
		isShowingMessage = true
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
			withAnimation {
				isShowingMessage = false
			}
		}
	}
	
	private func startWaveAnimationLoop() {
		Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
			withAnimation {
				if activeModal != .create {
					waveBounce.toggle()
				}
			}
		}
	}
	
	private func updateSelectedDeckAfterDeletion() {
		// Set selectedDeck to nil to avoid using a deleted deck
		selectedDeck = nil
	}
}

#Preview {
	DeckActionsView(
		decks: [Deck.sampleDeck],
		selectedDeck: .constant(Deck.sampleDeck),
		isShowingMessage: .constant(false),
		deleteDeck: .constant(false),
		activeModal: .constant(.none),
		showProgressView: .constant(false)
	)
	.modelContainer(for: Deck.self, inMemory: true)
	.environmentObject(DeckSelectionViewModel())
}
