//
//  MainSettingsView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 03/04/2025.
//

import SwiftUI

struct MainSettingsView: View {
	
	@State private var cacheSizeInMB: Int = 0
	@State private var clearCache = false
	var body: some View {
		VStack(alignment: .leading) {
			Section {
				HStack(spacing: 4) {
					Text("Cache is currently using")
					Text("\(cacheSizeInMB) MB")
					Text("of storage")
				}
				Divider()
				HStack {
					Text("Delete cached cards")
					Spacer()
					Button {
						clearCache.toggle()
					} label: {
						Image(systemName: "trash")
							.foregroundStyle(.red)
					}
				}
			} header: {
				Text("Cache".uppercased())
					.font(.caption)
					.fontWeight(.bold)
			}
			
			
		}
		.padding()
		.onAppear {
			updateCacheSize()
		}
		.alert("Clear cache?", isPresented: $clearCache) {
			Button(role: .cancel) {
				
			} label: {
				Text("Cancel")
			}
			Button("Clear", role: .destructive) {
				PersistentImageCache.shared.clearCache()
			}
		} message: {
			Text("This will clear \(cacheSizeInMB) of MB in cache.")
		}
	}
	func updateCacheSize() {
		cacheSizeInMB = PersistentImageCache.shared.getCacheSizeInMB()
	}
}

#Preview {
	MainSettingsView()
}
