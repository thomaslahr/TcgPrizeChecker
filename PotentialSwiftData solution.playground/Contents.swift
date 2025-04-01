import Cocoa

struct Card {
	let name: String
}

struct Deck {
	var cards: [Card] }

var cardsInDeck = 0

var cardNames = ["Gardevoir", "Kirlia", "Ralts", "Munkidori",]
	
var cards: [Card] = [] {
	didSet {
		print("was added")
		cardsInDeck += 1
		print("Cards in deck: \(cardsInDeck)")
	   }
   }



var deck = Deck(cards: cards)

for cardName in cardNames {
	print(cardName)
	cards.append(Card(name: cardName))
}

print("______________")
deck.cards = cards
//for card in cards {
//	print(card.name)
//}

for card in deck.cards {
	print(card.name)
}
