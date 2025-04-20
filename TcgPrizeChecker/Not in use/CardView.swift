//
//  CardView.swift
//  PokemonPrizeChecker
//
//  Created by Thomas Lahr on 29/10/2024.
//

//import SwiftUI
//import SwiftData
//
//struct CardView: View {
//	@Environment(\.modelContext) private var modelContext
//	
//	var cardNumber: String
//	var cardSetNumber: String
//	//@StateObject private var cardViewModel = CardViewModel(individualCard: Card.sampleData)
//	@StateObject private var cardViewModel = CardViewModel()
//	@GestureState private var zoom = 1.0
//	@State private var isZooming = false
//	
//	let defaultCategory: Category = .pokemon
//	let defaultHp = 0
//	let defaultStage: String = "BASIC"
//	let defaultAbilities: [Ability] = []
//	let defaultAttacks: [Attack] = []
//	
//	let defaultTrainerType: TrainerType = .item
//	let defaulTrainerEffect = "This Trainer card does nothing."
//	
//	@State private var showNavigationBar = true
//	
//	var body: some View {
//		ScrollView {
//			if cardViewModel.isLoading {
//				ProgressView()
//			} else {
//				VStack {
//					VStack {
//						ImageView(image: cardViewModel.image)
//							.scaleEffect(zoom)
//							.gesture(
//								MagnifyGesture()
//									.updating($zoom) { value, gestureState, transaction in
//										gestureState = value.magnification
//									}
//							)
//						// TODO: Bytte ut ex i teksten med ex-label som på kortet.
//						InfoView(name: cardViewModel.name,
//								 types: cardViewModel.types,
//								 category: cardViewModel.category ?? defaultCategory,
//								 hp: cardViewModel.hp ?? defaultHp,
//								 stage: cardViewModel.stage ?? defaultStage)
//					}
//					//.frame(minHeight: 300)
//					VStack {
//						AbilityView(abilities: cardViewModel.abilities ?? defaultAbilities)
//							.padding(.bottom, 15)
//						
//						AttackView(attacks: cardViewModel.attacks ?? defaultAttacks)
//						if cardViewModel.category == .trainer {
//							TrainerInfoView(trainerType: cardViewModel.trainerType ?? defaultTrainerType,
//											trainerCardEffect: cardViewModel.trainerCardEffect ?? defaulTrainerEffect)
//						}
//						
//						SetInfoView(rarity: cardViewModel.rarity,
//									regulationMark: cardViewModel.regulationMark,
//									cardSetShortName: cardViewModel.cardSetCopy?.name.cardSetShortName,
//									localId: cardViewModel.localId,
//									cardCountOfficial: cardViewModel.cardSetCopy?.cardCount.official,
//									cardSetName: cardViewModel.cardSetCopy?.name.rawValue, id: cardViewModel.id)
//						.padding(.top, 50)
//						
//						
//						HStack {
//							Button {
//								let imageURL = "\(cardViewModel.image)/high.webp"
//							
//								Task {
//									do {
//										let imageData = try await cardViewModel.downloadImage(
//											from: imageURL
//										)
//										cardViewModel.saveImagetoSwiftData(
//											imageData: imageData,
//											id: cardViewModel.id,
//											localId: cardViewModel.localId,
//											name: cardViewModel.name,
//											modelContext: modelContext,
//											cardToSave: "Deck"
//										)
//									} catch {
//										print("Error downloading image: \(error.localizedDescription)")
//									}
//									
//								}
//							} label: {
//								ZStack {
//									Circle()
//										.foregroundStyle(.blue)
//										.frame(maxWidth: 50)
//									Label("Add Card to Deck", systemImage: "plus")
//										.labelStyle(.iconOnly)
//										.foregroundStyle(.white)
//								}
//							}
//
//							Button {
//								let imageURL = "\(cardViewModel.image)/high.webp"
//							
//								Task {
//									do {
//										let imageData = try await cardViewModel.downloadImage(from: imageURL)
//										cardViewModel.saveImagetoSwiftData(
//												imageData: imageData,
//												id: cardViewModel.id,
//												localId: cardViewModel.localId,
//												name: cardViewModel.name,
//												modelContext: modelContext,
//												cardToSave: "Playable"
//											)
//									} catch {
//										print("Error downloading image: \(error.localizedDescription)")
//									}
//									
//								}
//							} label: {
//								
//								ZStack {
//									Circle()
//										.foregroundStyle(.red)
//										.frame(maxWidth: 50)
//									
//									Label("Add Card to Deck", systemImage: "heart.fill")
//										.labelStyle(.iconOnly)
//										.foregroundStyle(.white)
//									
//									
//								}
//							}						}
//					}
//				}
//			}
//			
//			
//		}
//		.scrollIndicators(.hidden)
//		.onAppear {
//			Task {
//				await cardViewModel.fetchCard(cardSetNumber: cardSetNumber, cardNumber: cardNumber)
//				print("An API call is made in the Card View")
//			}
//		}
//		.navigationTitle(cardViewModel.name)
//		
//		
//		.navigationBarTitleDisplayMode(.inline)
//		.padding(.horizontal, 25)
//		.background {
//			BlurredBackgroundView(cardNumber: cardNumber, image: cardViewModel.image)
//		}
//	}
//}
//
//
//#Preview {
//	CardView(cardNumber: "245", cardSetNumber: "sv01")
//}

