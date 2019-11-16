

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
