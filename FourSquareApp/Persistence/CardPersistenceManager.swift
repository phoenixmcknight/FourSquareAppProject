//
//  PhotoPersistence.swift
//  Weather App
//
//  Created by Michelle Cueva on 10/17/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import Foundation

//struct CardPersistenceManager {
//    static let manager = CardPersistenceManager()
//
//    func save(newCard: Card) throws {
//        try persistenceHelper.save(newElement: newCard)
//    }
//
//    func getCards() throws -> [Card] {
//       
//        return try persistenceHelper.getObjects()
//    }
//    
//    func deleteCard(title:String) throws {
//        do {
//            let newBooksElement = try getCards().filter({$0.cardTitle != title})
//            try persistenceHelper.replace(elements: newBooksElement)
//        
//        } catch {
//            print(error)
//        }
//    }
//
//    private let persistenceHelper = PersistenceHelper<Card>(fileName: "card.plist")
//
//    private init() {}
//}
