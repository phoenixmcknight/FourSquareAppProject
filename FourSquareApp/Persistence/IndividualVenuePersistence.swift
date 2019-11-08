//
//  PhotoPersistence.swift
//  Weather App
//
//  Created by Michelle Cueva on 10/17/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import Foundation

struct FourSquarePersistenceManager {
    static let manager = FourSquarePersistenceManager()

    func save(newCollection: SavedVenues) throws {
        try persistenceHelper.save(newElement: newCollection)
    }

    func getSavedVenues() throws -> [SavedVenues] {

        return try persistenceHelper.getObjects()
    }

    func deleteCard(title:String) throws {
        do {
            let letNewVenue = try getSavedVenues().filter({$0.venueName != title})
            try persistenceHelper.replace(elements: letNewVenue)

        } catch {
            print(error)
        }
    }

    private let persistenceHelper = PersistenceHelper<SavedVenues>(fileName: "individualVenue.plist")

    private init() {}
}

