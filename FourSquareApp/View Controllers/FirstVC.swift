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

enum RegisterCells:String {
    case mapCollectionViewCell
}

class LibraryViewController: UIViewController {
    
    //MARK: - Outlets
    lazy var searchBarOne:UISearchBar = {
        let sbo = UISearchBar()
        sbo.tag = 0
        return sbo
    }()
    lazy var searchBarTwo:UISearchBar = {
           let sbo = UISearchBar()
        sbo.tag = 1
           return sbo
       }()
    lazy var map:MKMapView = {
        let map = MKMapView()
        map.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        return map
    }()
    
    var venueData = [Venue]() {
        didSet {
            for i in self.venueData {
    let annotation = MKPointAnnotation()
    annotation.title = i.name
    annotation.coordinate = CLLocationCoordinate2D(latitude: i.location.lat, longitude: i.location.lng)
        self.map.addAnnotation(annotation)
        }
    }
    }
    
    lazy var mapCollectionView:UICollectionView = {
               var layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
               let colletionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout )
               layout.scrollDirection = .horizontal
               layout.itemSize = CGSize(width: 250, height: 250)
        colletionView.register(MapCollectionViewCell.self, forCellWithReuseIdentifier: RegisterCells.mapCollectionViewCell.rawValue)
        
               colletionView.dataSource = self
               colletionView.delegate = self
               colletionView.backgroundColor = .clear
               layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
               return colletionView
           }()
    
    private let locationManager = CLLocationManager()
    
    let searchRadius: CLLocationDistance = 2000
    
    var latLong:(Double,Double) = (40.742054,-73.769417) {
        didSet {
            let coordinateRegion = MKCoordinateRegion.init(center: CLLocationCoordinate2D(latitude: self.latLong.0, longitude: self.latLong.1), latitudinalMeters: 2 * searchRadius, longitudinalMeters: 2 * searchRadius)
            map.setRegion(coordinateRegion, animated: true)
            loadVenueData(query: searchStringQuery)
        }
    }
       
    var searchStringLatLong:String? = nil {
        didSet {
            guard let search = self.searchStringLatLong else {return}
            loadLatLongData(cityNameOrZipCode: search)
     }
    }
    var searchStringQuery:String = "Pizza" {
        didSet  {
            guard self.searchStringQuery != "" else {return}
            loadVenueData(query: self.searchStringQuery)
        }
    }
   

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        locationManager.delegate = self
        map.delegate = self
        searchBarOne.delegate = self
        searchBarTwo.delegate = self
        //map.userTrackingMode = .follow
        locationAuthorization()
        constriants()
        
    }

    
    private func constriants() {
        
        view.addSubview(searchBarOne)
        view.addSubview(searchBarTwo)
        view.addSubview(map)
        view.addSubview(mapCollectionView)
        searchBarOne.translatesAutoresizingMaskIntoConstraints = false
        searchBarTwo.translatesAutoresizingMaskIntoConstraints = false
        map.translatesAutoresizingMaskIntoConstraints = false
        mapCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBarOne.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 10),
            searchBarOne.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            searchBarOne.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            
            searchBarTwo.topAnchor.constraint(equalTo: searchBarOne.bottomAnchor,constant: 10),
            searchBarTwo.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            searchBarTwo.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            map.topAnchor.constraint(equalTo: searchBarTwo.bottomAnchor,constant: 10),
            map.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            map.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            map.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapCollectionView.topAnchor.constraint(equalTo: view.bottomAnchor,constant: -250),
            mapCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            mapCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20)
            
        ])
    }
    
    private func locationAuthorization() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
            
       
        
            
        case .authorizedAlways,.authorizedWhenInUse:
            map.showsUserLocation = true
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
       
         default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    //capture semantics explicit
    private func loadLatLongData(cityNameOrZipCode:String) {
        ZipCodeHelper.getLatLong(fromZipCode: cityNameOrZipCode)  { [weak self] (results) in
            switch results {
                
            case .success(let lat, let long):
                self?.latLong.0 = lat
                self?.latLong.1 = long
              
                print("good input")
            case .failure(_):
                print("bad input")
            }
        }
    }
    private func loadVenueData(query:String) {
        MapAPIClient.client.getMapData(query: query, latLong: "\(latLong.0),\(latLong.1)") { (result) in
            switch result {
                
            case .success(let data):
                self.venueData = data
            case .failure(let error):
                print(error)
            }
        }
    }
}
    
extension LibraryViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    
}
//
extension LibraryViewController: CLLocationManagerDelegate,MKMapViewDelegate,UISearchBarDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("New Location: \(locations)")
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Authorization status changed to \(status.rawValue)")
        switch status {
        case .authorizedAlways,.authorizedWhenInUse:
            locationManager.requestLocation()
            
            default:
            break
            }
        }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        switch searchBar.tag {
        case 0:
            searchBarOne.showsCancelButton = true
        case 1:
            searchBarTwo.showsCancelButton = true
        default:
            break
        }
       
        return true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
          switch searchBar.tag {
              case 0:
                  searchBarOne.showsCancelButton = false
                  searchBarOne.resignFirstResponder()
              case 1:
                  searchBarTwo.showsCancelButton = false
                  searchBarTwo.resignFirstResponder()
          default:
            break
                  
              }
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        switch searchBar.tag {
        case 0:
            
            let annotations = self.map.annotations
                                     self.map.removeAnnotations(annotations)
            guard let search = searchBarOne.text else {return}
            guard search != "" else {return}
            searchStringQuery = search
            searchBar.resignFirstResponder()
                    
            //        let searchRequest = MKLocalSearch.Request()
            //        searchRequest.naturalLanguageQuery = searchBar.text
            //        let activeSearch = MKLocalSearch(request: searchRequest)
            //        activeSearch.start { (response,error) in
            //            activityIndictator.stopAnimating()
            //            if response == nil {
            //                print(error)
            //            } else {
                         
                           
                   
                      
                    
                    
                            


                         
                        
        case 1:
            searchStringLatLong = searchBarTwo.text
        default:
            break
        }
       
            }
        }
    
    


