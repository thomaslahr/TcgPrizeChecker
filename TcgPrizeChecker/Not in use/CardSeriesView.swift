//
//  CardSeriesView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 04/11/2024.
//

//import SwiftUI
//
//struct CardSeriesView: View {
//	
////	init() {
////		//Endrer fargen på navigationTitle
////		UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.black]
////		UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
////	}
//	
//	let dataService = DataService()
//	
//	var body: some View {
//		NavigationStack {
//			VStack {
//				List {
//					cardSetSection(title: "Sword & Shield") { $0.cardSetNumber.contains("swsh") }
//					cardSetSection(title: "Scarlet & Violet") { $0.cardSetNumber.contains("sv") }
//				}
//			}
//			.navigationDestination(for: CardSetName.self) { cardSet in
//				//CardSetListView(cardSetNumber: cardSet.cardSetNumber)
//				CardSetMainView(cardSetNumber: cardSet.cardSetNumber)
//				
//			}
//		}
//		
//	}
//	//Denne funksjonen burde sikkert kjøres ut i en viewModel.
//	func cardSetSection(title: String, filter: (CardSetName) -> Bool) -> some View {
//		Section(title) {
//			ForEach(CardSetName.allCases.filter(filter), id: \.cardSetNumber) { cardSet in
//				ZStack{
//					HStack {
//							Text(cardSet.rawValue)
//							.frame(maxWidth: .infinity, alignment: .leading)
//						cardSet.cardSetLogo
//							.resizable()
//							.scaledToFit()
//							.frame(maxHeight: 30)
//							.padding(.trailing, 30)
//						Image(systemName: "arrow.forward")
//						}
//					
//
//						NavigationLink(cardSet.rawValue, value: cardSet)
//							.opacity(0)
//						
//							
//						
//				}
//				
//				
//			}
//		}
//	}
//}
//
//#Preview {
//	CardSeriesView()
//}
