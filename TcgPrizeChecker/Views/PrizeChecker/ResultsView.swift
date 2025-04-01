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
	var body: some View {
		
		ForEach(results) { result in
			let minutes = Int(result.elapsedTime) / 60
			let seconds = Int(result.elapsedTime) % 60
			VStack(alignment: .leading) {
					HStack {
						Text("Correct guesses: ")
							.bold()
						Text("\(result.correctAnswer).")
					}
					HStack{
						Text("Time spent: ")
							.bold()
						Text("\(minutes) min and \(seconds) sec.")
							
					}
				Text("Date:\(result.date.formatted(date: .numeric, time: .shortened)).")
				
			}
			Divider()
		}
	}
}

#Preview {

}

