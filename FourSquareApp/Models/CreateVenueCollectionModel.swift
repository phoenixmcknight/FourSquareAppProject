//
//  CreateVenueCollectionModel.swift
//  FourSquareApp
//
//  Created by Phoenix McKnight on 11/8/19.
//  Copyright © 2019 Phoenix McKnight. All rights reserved.
//

import Foundation

struct CreateVenueCollection:Codable {
    let name:String
    let image:Data
    var savedVenue:[SavedVenues] 
    //var savedVenue:[Venue] = []
    mutating func addSavedVenue(venue:SavedVenues) {
        self.savedVenue.append(venue)
    }
}
