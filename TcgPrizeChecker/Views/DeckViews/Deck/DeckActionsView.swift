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
	var selectedDeck: Deck?
	@Binding var isShowingMessage: Bool
	@Binding var deleteDeck: Bool
	@Binding var activeModal: DeckModal?
    var body: some View {
		ZStack {
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
						.font(.title)
				}
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding(.leading, 15)
			}
			HStack {
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
						.frame(maxWidth: .infinity, alignment: .center)
				}
			}
			HStack {
				if decks.count > 0 {
					withAnimation {
						Button {
							deleteDeck.toggle()
						} label: {
							Image(systemName: "trash.circle")
								.font(.title)
								.foregroundStyle(.red)
						}
						.alert("Are you sure you want to delete the deck?", isPresented: $deleteDeck) {
							Button("Cancel", role: .cancel) { }
							Button("Yes", role: .destructive) {
								if let selectedDeck = selectedDeck {
									modelContext.delete(selectedDeck)
									try? modelContext.save()
								}
							}
						}
					}
				}
			}
			.frame(maxWidth: .infinity, alignment: .trailing)
			.padding(.trailing, 15)
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
}

#Preview {
	DeckActionsView(
		decks: [Deck.sampleDeck],
		isShowingMessage: .constant(false),
		deleteDeck: .constant(false),
		activeModal: .constant(.none)
	)
	.modelContainer(for: Deck.self, inMemory: true)
	.environmentObject(DeckSelectionViewModel())
}
