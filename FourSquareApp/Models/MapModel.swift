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
    let name: ProviderName
    let icon: ProviderIcon
}

// MARK: - ProviderIcon
struct ProviderIcon: Codable {
    let iconPrefix: String
    let sizes: [Int]
    let name: IconName

    enum CodingKeys: String, CodingKey {
        case iconPrefix = "prefix"
        case sizes, name
    }
}

enum IconName: String, Codable {
    case deliveryProviderGrubhub20180129PNG = "/delivery_provider_grubhub_20180129.png"
    case deliveryProviderSeamless20180129PNG = "/delivery_provider_seamless_20180129.png"
}

enum ProviderName: String, Codable {
    case grubhub = "grubhub"
    case seamless = "seamless"
}

// MARK: - Location
struct Location: Codable {
    let address: String?
    let crossStreet: String?
    let lat, lng: Double
    let labeledLatLngs: [LabeledLatLng]
    let distance: Int
    let postalCode: String
    let cc: Cc
    let city: String
    let state: State
    let country: Country
    let formattedAddress: [String]
}

enum Cc: String, Codable {
    case us = "US"
}

enum Country: String, Codable {
    case unitedStates = "United States"
}

// MARK: - LabeledLatLng
struct LabeledLatLng: Codable {
    let label: Label
    let lat, lng: Double
}

enum Label: String, Codable {
    case display = "display"
}

enum State: String, Codable {
    case nj = "NJ"
    case ny = "NY"
}

enum ReferralID: String, Codable {
    case v1572900521 = "v-1572900521"
}

// MARK: - VenuePage
struct VenuePage: Codable {
    let id: String
}
