//
//  ResultsView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 17/12/2024.
//

import SwiftUI
import SwiftData

struct ResultsView: View {
	
	@Environment(\.modelContext) private var modelContext
	@Query var results: [PrizeCheckResult]
	
	@State private var showDeleteAlert = false
	@State private var resultToDelete: PrizeCheckResult?
	var body: some View {
		VStack {
			Text("Prize Checking History")
				.font(.title2)
				.fontWeight(.bold)
				.fontDesign(.rounded)
				.padding()
			ScrollView {
				ForEach(results) { result in
					let minutes = Int(result.elapsedTime) / 60
					let seconds = Int(result.elapsedTime) % 60
					HStack {
						VStack(alignment: .leading) {
							Text("Date:\(result.date.formatted(date: .numeric, time: .shortened)).")
								HStack{
									Text("Time spent: ")
									Text("\(minutes) min and \(seconds) sec.")
										.fontWeight(.black)
										
								}
							HStack {
								Text("Correct guesses: ")
								Text("\(result.correctAnswer)")
									.fontWeight(.black)
							}
							
						}
						Spacer()
						Button {
							resultToDelete = result
							showDeleteAlert = true
						} label: {
							Image(systemName: "trash.circle")
								.font(.title)
								.foregroundStyle(.red)
						}
						.padding(.trailing, 5)
					}
					.padding()
					Divider()
				}
			}
			.labelsHidden()
		}
		.alert("Delete result?", isPresented: $showDeleteAlert) {
			Button("Cancel", role: .cancel, action: { })
			Button("Delete", role: .destructive) {
				if let resultToDelete = resultToDelete {
					deleteResult(resultToDelete)
				}
			}
		} message: {
			Text("Are you sure? This cannot be undone.")
		}
	}
	
	private func deleteResult(_ result: PrizeCheckResult) {
		modelContext.delete(result)
		try? modelContext.save()
	}
}

#Preview {
	ResultsView()
}

