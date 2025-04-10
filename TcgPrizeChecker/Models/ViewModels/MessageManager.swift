//
//  MessageManager.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 10/04/2025.
//

import SwiftUI


class MessageManager: ObservableObject {
	
	@Published var messageContent = ""
	@Published  var isShowingMessage = false
	
	var messageTask: Task <Void, Never>?
	
	func showMessage() {
		self.messageTask?.cancel()
		
		// Briefly hide the message if already showing
		self.isShowingMessage = false
		
		// Wait a small delay, then show and start countdown
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			withAnimation {
				self.isShowingMessage = true
			}
			
			// Start the countdown AFTER showing
			self.messageTask = Task {
				try? await Task.sleep(nanoseconds: 1_500_000_000)
				await MainActor.run {
					withAnimation {
						self.isShowingMessage = false
					}
				}
			}
		}
	}

}
