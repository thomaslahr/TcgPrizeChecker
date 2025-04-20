//
//  CardViewModel.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 01/11/2024.
//

//import Foundation
//import SwiftData
//
//class CardViewModel: ObservableObject {
//	private let dataService = DataService()
//	
//	@Published var isLoading = true
//	
//	
//	//Properties som gjelder alle kort
//	@Published var category: Category?
//	@Published var image: String = ""
//	@Published var id: String = ""
//	@Published var localId: String = ""
//	@Published var name: String = ""
//	@Published var rarity: String = ""
//	@Published var regulationMark: String = ""
//	@Published var cardSetCopy: CardSetCopy?
//	
//	var cardSetNumber: String {
//		return cardSetCopy?.name.cardSetNumber ?? "Default card set number."
//	}
//	//Properties som kun gjelder Pokemon-kort:
//	@Published var hp: Int?
//	@Published var types: [EnergyType]?
//	@Published var stage: String?
//	@Published var evolveFrom: String?
//	@Published var retreat: Int?
//	@Published var abilities: [Ability]?
//	@Published var attacks: [Attack]?
//	
//	//Properties som kun gjelder Trainr-kort:
//	@Published var trainerType: TrainerType?
//	@Published var trainerCardEffect: String?
//	
//	@MainActor
//	func fetchCard(cardSetNumber: String, cardNumber: String) async {
//		do {
//			isLoading = true
//			let fetchedCard = try await dataService.fetchCard(cardSetNumber: cardSetNumber, cardNumber: cardNumber)
//			
//			category = fetchedCard.category ?? .pokemon
//			image = fetchedCard.image ?? ""
//			id = fetchedCard.id
//			localId = fetchedCard.localId
//			name = fetchedCard.name
//			rarity = fetchedCard.rarity ?? ""
//			regulationMark = fetchedCard.regulationMark ?? ""
//			cardSetCopy = fetchedCard.cardSetCopy
//			
//			
//			hp = fetchedCard.hp
//			types = fetchedCard.types
//			stage = fetchedCard.stage
//			evolveFrom = fetchedCard.evolveFrom
//			attacks = fetchedCard.attacks
//			retreat = fetchedCard.retreat
//			abilities = fetchedCard.abilities
//			
//			trainerType = fetchedCard.trainerType
//			trainerCardEffect = fetchedCard.trainerCardEffect
//			isLoading = false
//		} catch {
//			print(error.localizedDescription)
//			print("This is in the CardViewModel")
//		}
//	}
//	
//	func downloadImage(from urlString: String) async throws -> Data {
//		guard let url = URL(string: urlString) else {
//			throw CardSetError.invalidURL
//		}
//		do {
//			let (data, _) = try await URLSession.shared.data(from: url)
//			return data
//		} catch {
//			throw CardSetError.downloadFailed
//		}
//		
//	}
//	
//	@MainActor
//	func saveImagetoSwiftData(imageData: Data, id: String, localId: String, name: String, modelContext: ModelContext, cardToSave: String) {
//			do {
//				if cardToSave == "Deck" {
//					let storedCard = PersistentCard(
//						imageData: imageData ,
//						id: id,
//						localId: localId,
//						name: name,
//						uniqueId: UUID().uuidString
//					)
//					modelContext.insert(storedCard)
//					try modelContext.save()
//					print("Card successfully saved to SwiftData to a Deck.")
//				} else {
//					let storedCard = PlayableCard(
//						imageData: imageData,
//						id: id,
//						localId: localId,
//						name: name,
//						uniqueId: UUID().uuidString
//					)
//					modelContext.insert(storedCard)
//					try modelContext.save()
//					print("Card successfully saved to SwiftData as a Playable Card.")
//					
//				}
//			} catch {
//				print("Error saving the card to SwiftData: \(error.localizedDescription)")
//			}
//		
//	}
//}
