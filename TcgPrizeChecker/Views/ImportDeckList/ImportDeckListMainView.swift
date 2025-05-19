//
//  ImportDeckListMainView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 07/05/2025.
//

import SwiftUI

struct ImportDeckListMainView: View {
	@EnvironmentObject var networkMonitor: NetworkMonitor
	@State private var copiedText = ""
	@StateObject private var importDeckViewModel = ImportDeckViewModel()
	@State private var showTextEditor = false
	@State private var showSaveButton = false
	@State private var navigateToMatchedCards = false
	@Binding var activeModel: DeckModal?
	
	let pasteboard = UIPasteboard.general
	
	// ✅ Keep using the computed property
	private var parsedCards: [ParsedCardLine] {
		ParsedCardLine.parseDeckList(copiedText)
	}
	
	@State private var areWeOnline = false
	@State private var messageContent = "You are not online."
	@State private var showEmptyClipboardMessage = false
	@State private var isPasteButtonPressed = false
	
	var body: some View {
		
		let copiedTextShort = copiedText.count < 20
		
		NavigationStack {
			VStack {
				VStack {
					Text("Import Deck")
						.font(.title)
						.fontWeight(.bold)
						.fontDesign(.rounded)
						.foregroundStyle(GradientColors.primaryAppColor)
					
					TextEditor(text: $copiedText)
						.padding(.horizontal, 10)
						.padding(.vertical, 6)
						.frame(maxWidth: .infinity, maxHeight: copiedTextShort ? 0 : 400)
						.overlay {
							RoundedRectangle(cornerRadius: 12)
								.stroke(lineWidth: 2)
								.fill(GradientColors.primaryAppColor)
						}
						.scrollDisabled(copiedTextShort)
						
				}
				.transition(.move(edge: .bottom))
				.animation(.easeInOut(duration: 0.3), value: copiedTextShort)
				.padding()
				
				HStack {
					Button {
						if networkMonitor.isConnected {
							//Dette er ikke testet ordentlig ennå, så jeg er usikker på om det faktisk funker. Kommentaren kan slettes, så snart det er testet.
							if (pasteboard.string == nil || pasteboard.string?.isEmpty ?? true) {
								print("Hello????")
								messageContent = "There's no URL from the clipboard to copy."
								showEmptyClipboardMessage = true
								
								Task {
									try await Task.sleep(nanoseconds: 2_000_000_000)
									withAnimation(.easeIn(duration: 0.3)){
										showEmptyClipboardMessage = false
									}
								}
							}
							if copiedText.count < 20 {
								if let returnedString = pasteboard.string {
									copiedText = returnedString
								}
								isPasteButtonPressed = true
							} else {
								isPasteButtonPressed = false
								copiedText.removeAll()
							}
						} else {
							messageContent = "You need to connect to the internet."
						}
					} label: {
						Text(copiedTextShort ? "Paste from clipboard" : "Delete Text")
							.id(copiedTextShort ? "paste" : "delete")
							.foregroundStyle(.white)
							.padding()
							.background {
								if copiedText.count < 20 {
									RoundedRectangle(cornerRadius: 12)
										.foregroundStyle(GradientColors.primaryAppColor)
								} else {
									RoundedRectangle(cornerRadius: 12)
										.foregroundStyle(.red)
								}
							}
					}
				
					if isPasteButtonPressed {
						if networkMonitor.isConnected && copiedText.count > 20 {
							NavigationLink(value: parsedCards) {
										Text("Add cards to deck")
											.foregroundStyle(.white)
											.padding()
											.background {
												RoundedRectangle(cornerRadius: 12)
													.foregroundStyle(GradientColors.primaryAppColor)
												
											}
							}
						} else {
							Button {
								messageContent = "You need to connect to the internet."
							} label: {
								Text("Add cards to deck")
									.foregroundStyle(.white)
									.padding()
									.background {
										RoundedRectangle(cornerRadius: 12)
											.foregroundStyle(GradientColors.primaryAppColor)
									}
							}
						}
					}
				}
				.transition(.opacity)
				.animation(.easeInOut(duration: 0.1), value: copiedTextShort)
				.padding()
				.onChange(of: pasteboard) {
					if let returnedString = pasteboard.string {
						copiedText = returnedString
					}
				}
				// ✅ Define where to navigate
				.navigationDestination(for: [ParsedCardLine].self) { parsedCards in
					MatchedCardsView(importDeckViewModel: importDeckViewModel, activeModel: $activeModel, parsedCards: parsedCards)
				}
			}
			.frame(maxHeight: .infinity)
			.overlay {
			//	if !networkMonitor.isConnected || showEmptyClipboardMessage {
					MessageView(messageContent: messageContent)
						.opacity(!networkMonitor.isConnected || showEmptyClipboardMessage ? 1 : 0)
				//}
			}
		}
	}
}


#Preview {
	ImportDeckListMainView(activeModel: .constant(.importDeck))
}
