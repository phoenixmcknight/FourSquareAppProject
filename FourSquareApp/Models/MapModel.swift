import Foundation

// MARK: - Foursquare
struct Foursquare: Codable {
    let meta: Meta
    let response: Response?
    
    static func getTestData(from data:Data) -> [Venue]? {
        do {
            let newMap = try JSONDecoder().decode(Foursquare.self, from: data)
            return newMap.response?.venues
        } catch let error {
            print(error)
            return nil
        }
    }
}

// MARK: - Meta
struct Meta: Codable {
    let code: Int
    let requestID: String

    enum CodingKeys: String, CodingKey {
        case code
        case requestID = "requestId"
    }
}

// MARK: - Response
struct Response: Codable {
    let venues: [Venue]?
}

// MARK: - Venue
struct Venue: Codable {
    let id, name: String
    let location: Location?
    let categories: [Category]?
    let delivery: Delivery?
    let hasPerk: Bool
    let venuePage: VenuePage?

    
}

// MARK: - Category
struct Category: Codable {
    let id: String
    let name: String
    let pluralName: String
    let shortName: String
    let icon: CategoryIcon
    let primary: Bool
}

// MARK: - CategoryIcon
struct CategoryIcon: Codable {
    let iconPrefix: String
    let suffix: Suffix

    enum CodingKeys: String, CodingKey {
        case iconPrefix = "prefix"
        case suffix
    }
}

enum Suffix: String, Codable {
    case png = ".png"
}

// MARK: - Delivery
struct Delivery: Codable {
    let id: String
    let url: String
    let provider: Provider
}

// MARK: - Provider
struct Provider: Codable {
    let name: String?
    let icon: ProviderIcon
}

// MARK: - ProviderIcon
struct ProviderIcon: Codable {
    let iconPrefix: String
    let sizes: [Int]
    let name: String

    enum CodingKeys: String, CodingKey {
        case iconPrefix = "prefix"
        case sizes, name
    }
}





// MARK: - Location
struct Location: Codable {
    let address: String?
    let crossStreet: String?
    let lat, lng: Double
    let labeledLatLngs: [LabeledLatLng]?
    let distance: Int?
    let postalCode: String?
    let cc: String?
    let city: String?
    let state: String?
    let country: String?
    let formattedAddress: [String]
}





// MARK: - LabeledLatLng
struct LabeledLatLng: Codable {
    let label: String
    let lat, lng: Double
}





// MARK: - VenuePage
struct VenuePage: Codable {
    let id: String
}
