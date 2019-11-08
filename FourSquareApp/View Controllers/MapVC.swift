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
    case listTableViewCell
}

class MapViewController: UIViewController {
    
    //MARK: - Outlets
    lazy var searchBarOne:UISearchBar = {
        let sbo = UISearchBar()
        sbo.tag = 0
        sbo.placeholder = "Enter Type of Venue Here"
        sbo.backgroundColor = .lightGray
        sbo.barTintColor = .clear
        return sbo
    }()
    lazy var searchBarTwo:UISearchBar = {
        let sbo = UISearchBar()
        sbo.tag = 1
        sbo.placeholder = "Enter Location Here"
        sbo.backgroundColor = .lightGray
        sbo.barTintColor = .clear
        return sbo
    }()
    lazy var map:MKMapView = {
        let map = MKMapView()
        
        return map
    }()
    
    lazy var activityIndic:UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.hidesWhenStopped = true
        ai.style = .large
        ai.startAnimating()
        return ai
        
    }()
    
    var venueData = [Venue]() {
        didSet {
            loadImageData(venue: self.venueData)

            var count = 0
            for i in self.venueData {
                let annotation = MKPointAnnotation()
                annotation.title = i.name
                if let data = i.location {
                    annotation.coordinate = CLLocationCoordinate2D(latitude: data.lat, longitude: data.lng)
                    
                    annotation.subtitle = String(count)
                    self.map.addAnnotation(annotation)
                    count += 1
                }
            }
        }
        
    }
    
    var imageArray:[UIImage] = [] {
        didSet {
            if self.imageArray.count == venueData.count {
            mapCollectionView.reloadData()
            }
        }
    }
    
    lazy var mapCollectionView:UICollectionView = {
        var layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        let colletionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout )
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 125, height: 125)
        colletionView.register(MapCollectionViewCell.self, forCellWithReuseIdentifier: RegisterCells.mapCollectionViewCell.rawValue)
        
        
        colletionView.backgroundColor = .clear
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 10
        
        return colletionView
    }()
    
    private let locationManager = CLLocationManager()
    
    let searchRadius: CLLocationDistance = 1000
    
    var latLong:(Double,Double) = (0,0) {
        didSet {
            let coordinateRegion = MKCoordinateRegion.init(center: CLLocationCoordinate2D(latitude: self.latLong.0, longitude: self.latLong.1), latitudinalMeters: 2 * searchRadius, longitudinalMeters: 2 * searchRadius)
            map.setRegion(coordinateRegion, animated: true)
            loadVenueData(query: searchStringQuery)
            print(self.latLong)
        }
        
    }
    
    var searchStringLatLong:String? = nil {
        didSet {
            guard let search = self.searchStringLatLong else {return}
            loadLatLongData(cityNameOrZipCode: search)
        }
    }
    var searchStringQuery:String = "pizza" {
        didSet  {
            guard self.searchStringQuery != "" else {return}
            loadVenueData(query: self.searchStringQuery)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        
        locationManager.delegate = self
        map.delegate = self
        mapCollectionView.delegate = self
        mapCollectionView.dataSource = self
        searchBarOne.delegate = self
        searchBarTwo.delegate = self
        
        locationAuthorization()
        //map.userTrackingMode = .follow
        configureOutletConstraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .plain, target: self, action: #selector(showTableView))
        
    }
    
    @objc private func showTableView() {
        let tableview = ListTableViewController()
        tableview.venueTableViewData = venueData
        tableview.listImageArray = imageArray
        navigationController?.pushViewController(tableview, animated: true)
    }
    
    
    private func configureOutletConstraints() {
        
        view.addSubview(searchBarOne)
        view.addSubview(searchBarTwo)
        view.addSubview(map)
        view.addSubview(mapCollectionView)
        view.addSubview(activityIndic)
        searchBarOne.translatesAutoresizingMaskIntoConstraints = false
        searchBarTwo.translatesAutoresizingMaskIntoConstraints = false
        map.translatesAutoresizingMaskIntoConstraints = false
        mapCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        activityIndic.translatesAutoresizingMaskIntoConstraints = false
        
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
            mapCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            
            mapCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndic.centerXAnchor.constraint(equalTo: mapCollectionView.centerXAnchor),
            activityIndic.centerYAnchor.constraint(equalTo: mapCollectionView.centerYAnchor,constant:  -100),
            
            
            
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
            if latLong != (locationManager.location?.coordinate.latitude,locationManager.location?.coordinate.longitude) as! (Double, Double) {
                latLong = (locationManager.location?.coordinate.latitude,locationManager.location?.coordinate.longitude) as! (Double, Double)
            }
            genericAlertFunction(title: "Enter a Type of Food to See Nearby Eateries", message: "(I suggest Pizza)")
            
        case .denied:
            genericAlertFunction(title: "Enter a Location and Type of Food to See Nearby Eateries", message: "(I suggest Pizza)")
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
                self.activityIndic.stopAnimating()
            case .failure(let error):
                print(error)
            }
        }
    }
   
    private func genericAlertFunction(title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert,animated: true)
    }
    
    private func loadImageData(venue:[Venue]) {
        for i in venue {
            MapPictureAPIClient.manager.getFourSquarePictureData(venueID:i.id ) { (results) in
                switch results {
                case .failure(let error):
                    print(error)
                    self.imageArray.append(UIImage(systemName: "photo")!)
                case .success(let item):
                    // print("got something from pictureAPI")
                        if item.count > 0 {
                            ImageHelper.shared.getImage(urlStr: item[0].returnPictureURL()) {   (results) in
                                
                                
                                print(item[0].returnPictureURL())
                                // print("got something")
                                switch results {
                                case .failure(let error):
                                    print("picture error \(error)")
                                    self.imageArray.append(UIImage(systemName: "photo")!)
                                    print("test Load PHoto function")
                                case .success(let imageData):
                                    // print("got image")
                                
                                    DispatchQueue.main.async {
                                        
                                       self.imageArray.append(imageData)
                                    print("test Load PHoto function")
                                }
                                }
                            }
                        } else {
                            self.imageArray.append(UIImage(systemName: "photo")!)
                            print("test Load PHoto function")
                        }
                }
            }
        }
    }
}
    
extension MapViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return venueData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let venue = venueData[indexPath.item]
        let cell = mapCollectionView.dequeueReusableCell(withReuseIdentifier: RegisterCells.mapCollectionViewCell.rawValue, for: indexPath) as! MapCollectionViewCell
        
        cell.fourSquareImageView.image = imageArray[indexPath.item]
        cell.venueNameLabel.text = venue.name
              
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        map.showAnnotations(map.annotations.filter({$0.title == venueData[indexPath.item].name}), animated: true)
    
        
        
        
    }
    
    
}
//
extension MapViewController: CLLocationManagerDelegate,MKMapViewDelegate,UISearchBarDelegate {
    
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.isHighlighted = true
        if let annotation = view.annotation?.subtitle {
            let currentVenueTag = Int(annotation!)!
            
            let detailVC = DetailVenueVC()
          //  let venueType = venueData[currentVenueTag].categories?[0].shortName ?? "\(searchStringQuery.capitalized) Resturant"
            let currentVenue = SavedVenues(image: imageArray[currentVenueTag].pngData()!, venueName: venueData[currentVenueTag].name, venueType: venueData[currentVenueTag].returnCategory(searchString: searchStringQuery), tip: "")
          
            detailVC.currentVenue = currentVenue
            
            navigationController?.pushViewController(detailVC, animated: true)
            }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       var count = 0
        count += 1
        // print("New Location: \(locations)")
        print(count)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Authorization status changed to \(status.rawValue)")
        switch status {
        case .authorizedAlways,.authorizedWhenInUse:
            locationManager.requestLocation()
            latLong = (locationManager.location?.coordinate.latitude,locationManager.location?.coordinate.longitude) as! (Double, Double)
             genericAlertFunction(title: "Enter a Type of Food to See Nearby Eateries", message: "(I suggest Pizza)")
        case .denied:
          genericAlertFunction(title: "Enter a Location and Type of Food to See Nearby Eateries", message: "(I suggest Pizza)")
          print(CLAuthorizationStatus.denied)
            
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
 let annotations = self.map.annotations
        activityIndic.startAnimating()
        switch searchBar.tag {
        case 0:

                                     self.map.removeAnnotations(annotations)
            guard let search = searchBarOne.text else {return}
            guard search != "" else {return}
            searchStringQuery = search.capitalized
            searchBar.resignFirstResponder()

        case 1:
            searchStringLatLong = searchBarTwo.text
            self.map.removeAnnotations(annotations)
            resignFirstResponder()
        default:
            break
        }
       
            }
        }
    
    


