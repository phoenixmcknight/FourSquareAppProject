//
//  File.swift
//  FourSquareApp
//
//  Created by Phoenix McKnight on 11/4/19.
//  Copyright © 2019 Phoenix McKnight. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LibraryViewController: UIViewController {
    
//    //MARK: - Outlets
//    lazy var searchBarOne:UISearchBar = {
//        let sbo = UISearchBar()
//        return sbo
//    }()
//    lazy var searchBarTwo:UISearchBar = {
//           let sbo = UISearchBar()
//           return sbo
//       }()
//    lazy var map:MKMapView = {
//        let map = MKMapView()
//        return map
//    }()
//    
//    private let locationManager = CLLocationManager()
//    
//    let initialLocation = CLLocation(latitude: 40.742054, longitude: -73.769417)
//    let searchRadius: CLLocationDistance = 2000
//    
//    var searchString:String? = nil {
//        didSet {
//            map.addAnnotations(libraries.filter({$0.hasValidCoordinates}))
//        }
//    }
//    
//    private var libraries = [LibraryWrapper]() {
//        didSet {
//            mapView.addAnnotations( self.libraries.filter({$0.hasValidCoordinates}))
//        }
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        locationManager.delegate = self
//        mapView.delegate = self
//        locationEntry.delegate = self
//        mapView.userTrackingMode = .follow
//        locationAuthorization()
//        
//        
//    }
//    
//    private func loadData() {
//        libraries = LibraryWrapper.getLibraries(from: GetLocation.getData(name: "BklynLibraryInfo", type: "json"))
//    }
//    private func locationAuthorization() {
//        let status = CLLocationManager.authorizationStatus()
//        switch status {
//            
//       
//        
//            
//        case .authorizedAlways,.authorizedWhenInUse:
//            mapView.showsUserLocation = true
//            locationManager.requestLocation()
//            locationManager.startUpdatingLocation()
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//       
//         default:
//            locationManager.requestWhenInUseAuthorization()
//        }
//    }
//
//}
//
//extension LibraryViewController: CLLocationManagerDelegate,MKMapViewDelegate,UISearchBarDelegate {
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("New Location: \(locations)")
//    }
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        print("Authorization status changed to \(status.rawValue)")
//        switch status {
//        case .authorizedAlways,.authorizedWhenInUse:
//            locationManager.requestLocation()
//            
//            default:
//            break
//            }
//        }
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error)
//    }
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        searchString = searchText
//    }
//    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
//        locationEntry.showsCancelButton = true
//        return true
//    }
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        locationEntry.showsCancelButton = false
//        locationEntry.resignFirstResponder()
//    }
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let activityIndictator = UIActivityIndicatorView()
//        activityIndictator.center = self.view.center
//        activityIndictator.hidesWhenStopped = true
//        activityIndictator.startAnimating()
//        self.view.addSubview(activityIndictator)
//        searchBar.resignFirstResponder()
//        
//        let searchRequest = MKLocalSearch.Request()
//        searchRequest.naturalLanguageQuery = searchBar.text
//        let activeSearch = MKLocalSearch(request: searchRequest)
//        activeSearch.start { (response,error) in
//            activityIndictator.stopAnimating()
//            if response == nil {
//                print(error)
//            } else {
//                let annotations = self.mapView.annotations
//                self.mapView.removeAnnotations(annotations)
//                let latitude = response?.boundingRegion.center.latitude
//                let long = response?.boundingRegion.center.longitude
//                let newAnnotation = MKPointAnnotation()
//                newAnnotation.title = searchBar.text
//                newAnnotation.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: long!)
//                self.mapView.addAnnotation(newAnnotation)
//                
//                let coordinateRegion = MKCoordinateRegion.init(center: newAnnotation.coordinate, latitudinalMeters: self.searchRadius * 2.0, longitudinalMeters: self.searchRadius * 2.0)
//                self.mapView.setRegion(coordinateRegion, animated: true)
//            }
//        }
//    }
    }


