

import Foundation

struct CreateVenueCollection:Codable {
    let name:String
    let image:Data
    var savedVenue:[SavedVenues]
    mutating func addSavedVenue(venue:SavedVenues) {
        self.savedVenue.append(venue)
    }
}
