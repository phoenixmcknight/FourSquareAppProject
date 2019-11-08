//
//  File.swift
//  FourSquareApp
//
//  Created by Phoenix McKnight on 11/8/19.
//  Copyright © 2019 Phoenix McKnight. All rights reserved.
//

import Foundation

struct VenueCollectionPersistenceManager {
    static let manager = VenueCollectionPersistenceManager()

    func save(newCollection: CreateVenueCollection) throws {
        try persistenceHelper.save(newElement: newCollection)
    }

    func getSavedCollection() throws -> [CreateVenueCollection] {

        return try persistenceHelper.getObjects()
    }

    func deleteCollection(title:String) throws {
        do {
            let letNewCollection = try getSavedCollection().filter({$0.name != title})
            try persistenceHelper.replace(elements: letNewCollection)

        } catch {
            print(error)
        }
    }

    private let persistenceHelper = PersistenceHelper<CreateVenueCollection>(fileName: "venueCollection.plist")

    private init() {}
}

