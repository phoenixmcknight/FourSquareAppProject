import UIKit
import CoreLocation

enum LocationFetchingError: Error {
    case error(Error)
    case noErrorMessage
}

class ZipCodeHelper {
    private init() {}
    static func getLatLong(fromZipCode zipCode: String, completionHandler: @escaping (Result<(lat: Double, long: Double), LocationFetchingError>) -> Void) {
        let geocoder = CLGeocoder()
        DispatchQueue.global(qos: .userInitiated).async {
            geocoder.geocodeAddressString(zipCode){(placemarks, error) -> Void in
                DispatchQueue.main.async {
                    if let placemark = placemarks?.first, let coordinate = placemark.location?.coordinate  {
                        completionHandler(.success((coordinate.latitude, coordinate.longitude)))
                    } else {
                        let locationError: LocationFetchingError
                        if let error = error {
                            locationError = .error(error)
                        } else {
                            locationError = .noErrorMessage
                        }
                        completionHandler(.failure(locationError))
                    }
                }
            }
        }
    }
//    static func getLatLongFromCityName(fromCityName cityName: String, completionHandler: @escaping (Result<(lat: Double, long: Double,name:String), LocationFetchingError>) -> Void) {
//        let geocoder = CLGeocoder()
//        DispatchQueue.global(qos: .userInitiated).async {
//            geocoder.geocodeAddressString(cityName){(placemarks, error) -> Void in
//                DispatchQueue.main.async {
//                    if let placemark = placemarks?.first, let coordinate = placemark.location?.coordinate, let name = placemark.locality  {
//                        completionHandler(.success((coordinate.latitude, coordinate.longitude,name)))
//                    } else {
//                        let locationError: LocationFetchingError
//                        if let error = error {
//                            locationError = .error(error)
//                        } else {
//                            locationError = .noErrorMessage
//                        }
//                        completionHandler(.failure(locationError))
//                    }
//                }
//            }
//        }
//    }
}
