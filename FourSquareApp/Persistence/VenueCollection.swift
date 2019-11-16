

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
   func replaceAllFunction(newCollection:[CreateVenueCollection]) throws {
        do {
            try persistenceHelper.replace(elements: newCollection)
            
        }
    }

    private let persistenceHelper = PersistenceHelper<CreateVenueCollection>(fileName: "venueCollection.plist")

    private init() {}
}

