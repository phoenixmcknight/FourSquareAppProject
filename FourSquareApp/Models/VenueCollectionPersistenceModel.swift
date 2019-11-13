//
//  VenueCollectionPersistence.swift
//  FourSquareApp
//
//  Created by Phoenix McKnight on 11/8/19.
//  Copyright © 2019 Phoenix McKnight. All rights reserved.
//

import Foundation


struct SavedVenues:Codable {
    let image:Data
    let venueName:String
    let venueType:String
    var tip:String
    let id:String
    let address:String
    let lat:Double?
    let long:Double?
}
