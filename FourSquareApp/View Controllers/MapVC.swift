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



class MapViewController: UIViewController {
    //MARK: Variables
    
    var venueData = [Venue]() {
        didSet {
            imageArray = []
            loadImageData(venue: self.venueData)
            
            for i in self.venueData {
                let annotation = MKPointAnnotation()
                annotation.title = i.name
                if let data = i.location {
                    annotation.coordinate = CLLocationCoordinate2D(latitude: data.lat, longitude: data.lng)
                    annotation.subtitle = i.id
                    self.map.addAnnotation(annotation)
                    
                }
            }
        }
    }
    
    var imageArray:[UIImage] = [] {
        didSet {
            
            guard self.imageArray.count == venueData.count else {return}
            mapCollectionView.reloadData()
            
        }
    }
    private let locationManager = CLLocationManager()
    
    let searchRadius: CLLocationDistance = 1000
    
    var coordinate:CLLocationCoordinate2D? = CLLocationCoordinate2D() {
        didSet {
            let coordinateRegion = MKCoordinateRegion(center: self.coordinate ?? CLLocationCoordinate2D(), latitudinalMeters: 2 * searchRadius, longitudinalMeters: 2 * searchRadius)
            map.setRegion(coordinateRegion, animated: true)
            guard searchStringQuery != "" else {activityIndic.stopAnimating()
                return}
            loadVenueData(query: searchStringQuery)
        }
    }
    
    var searchStringLatLong:String? = nil {
        didSet {
            guard let search = self.searchStringLatLong else {return}
            loadLatLongData(cityNameOrZipCode: search)
        }
    }
    var searchStringQuery:String = "" {
        didSet  {
            guard self.searchStringQuery != ""  else {return}
            
            loadVenueData(query: self.searchStringQuery)
        }
    }
    var selectedVenue:SavedVenues!
    
    //MARK: - Views
    lazy var searchBarOne:UISearchBar = {
        let sbo = UISearchBar()
        sbo.tag = 0
        sbo.placeholder = "Search Venues"
        sbo.searchBarStyle = .minimal
        sbo.setImage(UIImage(systemName: "magnifyingglass.circle"), for: .search, state: .normal)
        sbo.searchTextField.textColor = .red
        
        return sbo
    }()
    lazy var searchBarTwo:UISearchBar = {
        let sbo = UISearchBar()
        sbo.tag = 1
        sbo.placeholder = "Enter Location Here"
        sbo.searchBarStyle = .minimal
        sbo.setImage(UIImage(systemName: "magnifyingglass.circle"), for: .search, state: .normal)
        sbo.searchTextField.textColor = .red
        
        return sbo
    }()
    lazy var map:MKMapView = {
        let map = MKMapView()
        map.userTrackingMode = .follow
        
        return map
    }()
    
    lazy var activityIndic:UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.hidesWhenStopped = true
        ai.style = .large
       // ai.center = view.center
        return ai
        
    }()
    
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
    
    lazy var annotationTapGesture:UITapGestureRecognizer = {
        let atg = UITapGestureRecognizer()
        
        atg.addTarget(self, action: #selector(annotationCalloutClicked))
        return atg
    }()
    
    lazy var viewArray = [self.searchBarOne,self.searchBarTwo,self.map,self.mapCollectionView]
    
    
    //MARK:LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        addViewsToSubView()
        configureSearchBarConstriants()
        configureMapConstraints()
        configureCollectionViewConstraints()
        viewGradientLayer()
        locationAuthorization()
    }
    //MARK: @objc Functions
    @objc private func showTableView() {
        let tableview = ListTableViewController()
        tableview.venueTableViewData = venueData
        tableview.listImageArray = imageArray
        tableview.precedingVC = .mapVC
        navigationController?.pushViewController(tableview, animated: true)
    }
    
    @objc private func annotationCalloutClicked() {
        let detailVC = DetailVenueVC()
        detailVC.precedingVC = .mapVC
        detailVC.currentVenue = selectedVenue
        navigationController?.pushViewController(detailVC, animated: true)
    }
    //MARK:Add ViewsToSubviews
    private func addViewsToSubView() {
        for aView in viewArray {
            view.addSubview(aView)
            aView.translatesAutoresizingMaskIntoConstraints = false
        }
        view.addSubview(activityIndic)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .plain, target: self, action: #selector(showTableView))
    }
    
    //MARK:Set Delegates
    private func setDelegates() {
        locationManager.delegate = self
        map.delegate = self
        mapCollectionView.delegate = self
        mapCollectionView.dataSource = self
        searchBarOne.delegate = self
        searchBarTwo.delegate = self
    }
    //MARK: Set Constraints
    private func configureSearchBarConstriants() {
        NSLayoutConstraint.activate([
            searchBarOne.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 10),
            searchBarOne.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            searchBarOne.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -20),

            searchBarTwo.topAnchor.constraint(equalTo: searchBarOne.bottomAnchor,constant: 10),
            searchBarTwo.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            searchBarTwo.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -20)
        ])
    }
  
    private func configureMapConstraints() {
        NSLayoutConstraint.activate([
            map.topAnchor.constraint(equalTo: searchBarTwo.bottomAnchor,constant: 10),
            map.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            map.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            map.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureCollectionViewConstraints() {
        NSLayoutConstraint.activate([
            mapCollectionView.topAnchor.constraint(equalTo: view.bottomAnchor,constant: -250),
            mapCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            mapCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            
            mapCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //MARK: Customize View Gradient Collor
    private func viewGradientLayer() {
        
        CustomLayer.shared.setGradientBackground(colorTop: .black, colorBottom: .lightGray, newView: view)
        
    }
    
    
    //MARK: Location Functions
    
    private func locationAuthorization() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
            
        case .authorizedAlways,.authorizedWhenInUse:
            map.showsUserLocation = true
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            
            useUserLocationAlert()
            
            
        case .denied:
            genericAlertFunction(title: "Enter a Location and Type of Food to See Nearby Venues", message: "(I suggest Pizza)")
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func loadLatLongData(cityNameOrZipCode:String) {
        ZipCodeHelper.getLatLong(fromZipCode: cityNameOrZipCode) { [weak self] (results) in
            switch results {
                
            case .success(let coordinateData):
                
                self?.coordinate = coordinateData
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK: Load Data Functions
    private func loadVenueData(query:String) {
        guard searchStringLatLong != "" else {return}
        guard let lat = coordinate?.latitude, let long = coordinate?.longitude else {return}
        
        MapAPIClient.client.getMapData(query: query, latLong: "\(lat),\(long)") { (result) in
            switch result {
                
            case .success(let data):
                self.venueData = data
                
                self.activityIndic.stopAnimating()
            case .failure(let error):
                print(error)
            }
        }
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
    
    //MARK: Alert Functions
    
    private func genericAlertFunction(title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert,animated: true)
    }
    
    private func useUserLocationAlert() {
        let alert = UIAlertController(title: "Use Current Location?", message: "", preferredStyle: .actionSheet)
        let yes = UIAlertAction(title: "Yes", style: .default) { [weak self] (result) in
            
            self?.coordinate = self?.locationManager.location?.coordinate
            if let lastLocation = self?.locationManager.location {
                let geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(lastLocation) { (placemark, error) in
                    guard error == nil else {return}
                    self?.searchBarTwo.placeholder =  placemark?[0].locality
                    
                    self?.navigationItem.title = placemark?[0].locality
                    
                }
            }
            self?.dismiss(animated: true) {
                self?.genericAlertFunction(title: "Enter a Type of Food to See Nearby Venues", message: "(I suggest Pizza)")
            }
        }
        let no = UIAlertAction(title: "No", style: .destructive) { [weak self] (result)  in
            self?.dismiss(animated: true) {
                self?.genericAlertFunction(title: "Enter a Location and Type of Food to See Nearby Venues", message: "(I suggest Pizza)")
                
                UIView.animate(withDuration: 1.5, delay: 0.0, options: [.transitionCrossDissolve], animations: {
                    self?.searchBarOne.alpha = 0.0
                    self?.searchBarOne.isUserInteractionEnabled = false
                }, completion: nil)
            }
            
        }
        alert.addAction(yes)
        alert.addAction(no)
        present(alert,animated: true)
    }
    
    
}


extension
MapViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return venueData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = mapCollectionView.dequeueReusableCell(withReuseIdentifier: RegisterCells.mapCollectionViewCell.rawValue, for: indexPath) as! MapCollectionViewCell
        
        cell.fourSquareImageView.image = imageArray[indexPath.item]
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let currentAnnotation = map.annotations.filter({$0.subtitle == venueData[indexPath.item].id})
        
        let region = MKCoordinateRegion(center: currentAnnotation[0].coordinate, latitudinalMeters: 0, longitudinalMeters: 0)
        
        map.showAnnotations(currentAnnotation, animated: true)
        map.setRegion(region, animated: true)
    }
}
//
extension MapViewController: CLLocationManagerDelegate,MKMapViewDelegate,UISearchBarDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        
        guard let subtitle = view.annotation?.subtitle else {return}
        
        view.detailCalloutAccessoryView = UIButton(type: .infoLight)
        view.detailCalloutAccessoryView?.addGestureRecognizer(annotationTapGesture)
        view.canShowCallout = true
        view.isOpaque = true
        guard let index = venueData.firstIndex(where: {$0.id == subtitle} )  else {return}
        
        
        selectedVenue = SavedVenues(image: imageArray[index].pngData()!, venueName: venueData[index].name, venueType: venueData[index].returnCategory(), tip: "", id: venueData[index].id,address: venueData[index].location?.returnFormattedAddress() ?? "Location Data Unavailable",lat: venueData[index].location?.lat,long: venueData[index].location?.lng)
        
        
        
        
        
    }
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("New Location: \(locations)")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Authorization status changed to \(status.rawValue)")
        switch status {
        case .authorizedAlways,.authorizedWhenInUse:
            locationManager.requestLocation()
            useUserLocationAlert()
            // coordinate = locationManager.location!.coordinate
            
            
        case .denied:
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
            searchBarOne.setImage(UIImage(systemName: "magnifyingglass.circle.fill"), for: .search, state: .normal)
        case 1:
            searchBarTwo.showsCancelButton = true
            searchBarTwo.setImage(UIImage(systemName: "magnifyingglass.circle.fill"), for: .search, state: .normal)
        default:
            break
        }
        
        return true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        switch searchBar.tag {
        case 0:
            searchBarOne.setImage(UIImage(systemName: "magnifyingglass.circle"), for: .search, state: .normal)
        case 1:
            searchBarTwo.setImage(UIImage(systemName: "magnifyingglass.circle"), for: .search, state: .normal)
        default:
            break
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        switch searchBar.tag {
        case 0:
            searchBarOne.showsCancelButton = false
            searchStringQuery = ""
            searchBar.placeholder = ""
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
        
        switch searchBar.tag {
        case 0:
            activityIndic.startAnimating()
            self.map.removeAnnotations(annotations)
            guard let search = searchBarOne.text else {return}
            guard search != "" else {return}
            searchStringQuery = search.capitalized
            searchBarOne.placeholder = searchBarOne.text?.capitalized
            
            searchBar.resignFirstResponder()
            
        case 1:
            UIView.transition(with: self.searchBarTwo, duration: 2.5, options: [.transitionCrossDissolve], animations: {
                self.searchBarOne.alpha = 1.0
            }, completion: nil)
            
            searchBarOne.isUserInteractionEnabled = true
            activityIndic.startAnimating()
            guard let search = searchBarTwo.text else {return}
            navigationItem.title = search.capitalized
            
            searchStringLatLong = search
            searchBarTwo.placeholder = search.capitalized
            self.map.removeAnnotations(annotations)
            resignFirstResponder()
        default:
            break
        }
        
    }
}




